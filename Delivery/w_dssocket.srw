HA$PBExportHeader$w_dssocket.srw
forward
global type w_dssocket from window
end type
type cb_ok from commandbutton within w_dssocket
end type
type cbx_debug from checkbox within w_dssocket
end type
type cb_runall from commandbutton within w_dssocket
end type
type cb_1 from commandbutton within w_dssocket
end type
type st_4 from statictext within w_dssocket
end type
type st_3 from statictext within w_dssocket
end type
type mle_send from multilineedit within w_dssocket
end type
type st_msg from statictext within w_dssocket
end type
type cb_writexml from commandbutton within w_dssocket
end type
type cb_6 from commandbutton within w_dssocket
end type
type cb_test from commandbutton within w_dssocket
end type
type cb_readxml from commandbutton within w_dssocket
end type
type cb_3 from commandbutton within w_dssocket
end type
type ole_dssocket from olecustomcontrol within w_dssocket
end type
type cb_send from commandbutton within w_dssocket
end type
type mle_output from multilineedit within w_dssocket
end type
type sle_remoteport from singlelineedit within w_dssocket
end type
type st_2 from statictext within w_dssocket
end type
type st_1 from statictext within w_dssocket
end type
type sle_remotehost from singlelineedit within w_dssocket
end type
type cb_connect from commandbutton within w_dssocket
end type
type rr_1 from roundrectangle within w_dssocket
end type
type ln_1 from line within w_dssocket
end type
end forward

global type w_dssocket from window
integer x = 498
integer y = 500
integer width = 3899
integer height = 1900
boolean titlebar = true
string title = "LMS Routing/Rating Call"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
event ue_showdebugtools ( )
cb_ok cb_ok
cbx_debug cbx_debug
cb_runall cb_runall
cb_1 cb_1
st_4 st_4
st_3 st_3
mle_send mle_send
st_msg st_msg
cb_writexml cb_writexml
cb_6 cb_6
cb_test cb_test
cb_readxml cb_readxml
cb_3 cb_3
ole_dssocket ole_dssocket
cb_send cb_send
mle_output mle_output
sle_remoteport sle_remoteport
st_2 st_2
st_1 st_1
sle_remotehost sle_remotehost
cb_connect cb_connect
rr_1 rr_1
ln_1 ln_1
end type
global w_dssocket w_dssocket

type variables
string is_Title
string is_ResponseType, is_Client, is_RateType, is_Scac, is_Mode, is_LineHaul
string is_SFCity, is_SFZip, is_SFState, is_SFCntry //Ship-From Address info.
string is_STCode, is_STCity, is_STZip, is_STState, is_STCntry //Ship-To Address Info.
string is_RouteRate //'Routing' or 'Rating'
integer ii_color //for toggling message color
String is_WHCode, is_Carrier, is_UserField6, is_UserField8
datawindow idw_dm, idw_dm_other // 02/10/06 - idw_dm_other added for Carrier Prioritized Picking
boolean ib_LMSError //flag's error processing for LMS Response (successive <Code>, <Description> are for error)
string is_LMSErrCode, is_LMSErrDesc
boolean ib_Debug //turns on/off debug messaging (not implemented yet)
boolean ib_Connected //having trouble trapping the Connection.  Setting ib_Connected in 'OCX_Connect' event
//capture 3rd Party address info (for setting into Delivery Notes)
string is_Name, is_Address, is_City, is_State, is_Zip, is_Cntry
string is_ShipAcct
str_parms istrParms
string is_UpdateOrder
decimal id_PreviousWgt //weight stored on previous call (for Carrier Prioritized Pick print)
long il_CartonCount /* 08/15/07 - passing carton count to LMS (setting it in 'wf_GetWeight') */

end variables

forward prototypes
public subroutine wf_sendxml ()
public function boolean wf_BigMsgBox (string as_Msg)
public function string wf_parseit (string ps_xmltext)
public function string NoNull (string as_str)
public subroutine wf_runall ()
public function boolean wf_validaterequest ()
public function boolean wf_readxml ()
public function integer set_xml_value (string ps_field, string ps_value)
public subroutine showvalues ()
public subroutine wf_updateorder ()
public subroutine wf_setaddr (string as_addr_type)
public subroutine wf_writexml ()
public function boolean wf_connect ()
public function double wf_getweight ()
public subroutine msg (string as_msg)
end prototypes

event ue_showdebugtools;	this.width=3900
	this.height=1900
	cbx_Debug.checked = false
	ib_Debug=false
end event

public subroutine wf_sendxml ();string ls_data

//messagebox ("","Padding to 1024")
ls_data=mle_send.text + space(1024 - len(mle_send.text))
//messagebox("Length:",string(len(ls_data)))
ole_dssocket.object.send = ls_data
//ole_dssocket.object.action=1 //close connection
end subroutine

public function boolean wf_BigMsgBox (string as_Msg);timer(0)
cb_OK.visible=true
cb_OK.Setfocus()
cb_OK.default = true
st_msg.text = as_msg
return true
end function

public function string wf_parseit (string ps_xmltext);
/*ParseIt is called recursively so 'Root' always represents a node and any children
	- 01/30/04 - Need to explore making XMLDoc Instance and using 'SelectNodes' and 'SelectSingleNode' 
							 methods (etc.) */
OleObject XMLdoc, Root, CurNode, sibling, xParent
string ls_xml

//messagebox("ue_ParseIt",ps_xmltext)
ls_xml=ps_xmltext

XMLDoc = Create OLEObject
if XMLDoc.ConnecttoNewObject ("MSXML2.DOMDocument.6.0") <> 0 then	//ET3 2013-02-18: change per MS for Win7
//if XMLDoc.ConnecttoNewObject ("MSXML2.DOMDocument") <> 0 then	//ET3 2012-10-18: change per MS for Win7
//if XMLDoc.ConnecttoNewObject ("MSXML2.DOMDocument.4.0") <> 0 then
	MessageBox (is_title, "Error, Can't create DOM object!")
	return "err"
end if

XMLDoc.Async = false
XMLDoc.ValidateonParse = true
//XMLDoc.LoadXML ("<xmlROOT> <xmlCHILD1> Child1Text </xmlCHILD1> <xmlCHILD2> Child2Text </xmlCHILD2> </xmlROOT>")
XMLDoc.LoadXML (ls_xml)
if XMLDoc.parseError.ErrorCode <> 0 then
	MessageBox (is_title, "XML parsing error - " + String (XMLDoc.parseError.reason))
	Destroy XMLDoc
	return "err2"
end if

Root = XMLdoc.documentElement
//MessageBox ("Root node name", String (Root.nodeName) + ", FirstChild: " + string(Root.FirstChild.nodename)  + ", NextSibling: " + string(Root.NextSibling.nodename))
//MessageBox ("Root node name", String (Root.nodeName) + ", FirstChild: " + string(Root.FirstChild.nodename))

// PowerBuilder does not support COM Variant data type so the only way to scan siblings is using nextSibling function

//Here's the new, recursive, loop:
if not IsNull (Root.firstChild) then
	CurNode = Root.firstChild
	//MessageBox ("CurNode.xml", String (CurNode.nodeName) + " = " + String (CurNode.xml))
	//messagebox("NodeType", string(CurNode.nodetypestring))
	//MessageBox ("CurNode.text", String (CurNode.nodeName) + " = " + String (CurNode.Text))
	if string(CurNode.nodetypestring) = "text" then
		//MessageBox ("CurNode.text", String(curnode.parentnode.nodename) + " = " + String (CurNode.Text))
		set_xml_value(String(curnode.parentnode.nodename), String (CurNode.Text))
	else
		wf_parseit(CurNode.xml)
	end if
	if not IsNull (CurNode.NextSibling) then
		do while not IsNull (CurNode.nextSibling)
			//messagebox(string(curnode.nodename) + "'s NextSibling", string(CurNode.nextSibling.nodename))
			Sibling = CurNode.nextSibling
			if Sibling.NodeName = "Error" then
				//What if Error occurs in FirstChild? (<Common> should always be FirstChild)
				//messagebox("ErrorNode","Processing Error...")
				ib_LMSError=true
			end if
			wf_parseit(sibling.xml)
			//messagebox ("end of error","")
			ib_LMSError=false
			is_LMSErrCode = ""
			is_LMSErrDesc = ""
			curnode=curnode.nextsibling
		loop
	end if //loop 
end if


Destroy XMLDoc

return "done"
end function

public function string NoNull (string as_str);if isnull(as_str) then
	return ""
else
	return as_str
end if
end function

public subroutine wf_runall ();	msg("Calling 'wf_Connect'")
  wf_Connect() 
return
wf_WriteXML()
if wf_ValidateRequest() then
	msg ("Validated")
 /*- Routing:
     (Check for orig/dest/wgt/scac)
   - Rating:
    - (Same as Routing?) */
	if ib_Connected then
		msg("Connected, calling 'SendXML'")
    wf_SendXML()
		msg("Calling 'ReadXML'")
    wf_ReadXML()
		msg("Calling 'UpdateOrder'")
    wf_UpdateOrder() //(Called from wf_ReadXML?)
	else
		messagebox(is_title, "Not Connected")
  end if
else
	msg("Not Validated")
end if

end subroutine

public function boolean wf_validaterequest ();/*
 - Routing:
  - (Check for orig/dest/wgt/scac)
 - Rating:
  - (Same as Routing?)
*/

if isnull(is_SFCity) or is_SFCity = "" then
	messagebox (is_title, "Invalid Ship-From data.")
	wf_BigMsgBox ("Invalid Ship-From data.")
	return false
elseif isnull(is_STCity) or is_STCity = "" then
	messagebox (is_title, "Invalid Ship-To data.")
	wf_BigMsgBox ("Invalid Ship-To data.")
	return false
//more validation...
end if


return true
end function

public function boolean wf_readxml ();//copied first 'working' parse to w_dssocket.ue_temp
//Look at SelectNodes and SelectSingleNode methods - don't we just want SCAC?

OleObject XMLdoc, Root, Child, sibling
string ls_xml
long ll_VerPos
/*strip the version (<?xml version="1.0"?> from the string before parsing...
(should we do this upon receiving xml from LMS?)*/

ls_xml=mle_output.text
ll_VerPos=pos(ls_xml,"?>")
if ll_verPos>0 then
	ls_xml=mid(ls_xml,ll_verPos + 2)
	mle_output.text=ls_xml
end if
//ue_ParseIt should return boolean or int...
ls_xml = wf_parseit(ls_xml)
ShowValues()

Destroy XMLDoc
return true

end function

public function integer set_xml_value (string ps_field, string ps_value);string ls_field, ls_value

ls_field=ps_field
/*Should these be particular to Route/Rate?
   - We reallyl only care about: SCAC, LineHaul, Error*/
CHOOSE CASE ps_field
	case "ResponseType"
		is_ResponseType=ps_value
	case "Client"
		is_Client=ps_value
	case "RateType"
		is_RateType=ps_value
	case "Scac"
		is_Scac=ps_value
	case "Mode"
		is_Mode=ps_value
	case "LineHaul"
		is_LineHaul = ps_value
	CASE  "Code"
		if ib_LMSError then is_LMSErrCode = ps_value
	CASE  "Description"
		if ib_LMSError then is_LMSErrDesc = ps_value
		Messagebox (is_title, "Error - " + is_LMSErrCode + " - " + is_LMSErrDesc)
	CASE "Name"
		is_Name = ps_value
	CASE "Address"
		is_Address = ps_value
	CASE "City"
		is_City = ps_value
	CASE "State"
		is_State = ps_value
	CASE "Zip"
		is_Zip = ps_value
	CASE "Country"
		is_Cntry = ps_value
	case "ShipperAcct"
		is_ShipAcct = ps_value
	CASE ELSE
		ls_field="Undefined(" + ps_field +")"
END CHOOSE
msg ("Set Field: " + ls_field + " = " + ps_value)

return 1

/*
	<Common>
		<ResponseType>WMSRATE</ResponseType>
		<Client>240</Client>
	</Common>
	<WMSRATE>
	<Rates>
		<RateType>CL</RateType>
		<Scac>U11</Scac>
		<Mode>PKG</Mode>
		<Service>GND</Service>
		<TransitTime>0</TransitTime>
		<CustomerRouted>N</CustomerRouted>
		<Terms></Terms>
		<ShipperAcct></ShipperAcct>
		<AddressInfo>
			<Name></Name>
			<Address></Address>
			<City></City>
			<State></State>
			<Zip></Zip>
			<Country></Country>
		</AddressInfo>
		<LineHaul>39.39</LineHaul>
		<LineHaulCurr>USD</LineHaulCurr>
		<TotalAccessorialAmt>0</TotalAccessorialAmt>
		<AccessorialCurr>USD</AccessorialCurr>
	</Rates>
	<Accessorials></Accessorials>
	</WMSRATE>
*/
end function

public subroutine showvalues ();string ls_msg
ls_msg="ResponseType=" + is_ResponseType
ls_msg += char(13) + "Client=" + is_Client
ls_msg += char(13) + "Scac=" + is_Scac
ls_msg += char(13) + "Rate=" + is_LineHaul
ls_msg += char(13) + "Acct=" + is_ShipAcct
//ls_msg += char(13) + "Mode=" + is_Mode
		
msg("Stored Values:" + char(13) + ls_msg)
end subroutine

public subroutine wf_updateorder ();string ls_3rdParty, ls_DelNote, ls_ErrText, ls_msg, ls_PLNotes, lsWarehouse, lsRouteInd, lsTermCode
string ls_3rdPartyCR // 09/25/06
long ll_Pos

if is_RouteRate = 'Routing' then
	/*User_Field8 is set previously, but ib_changed is not flagged unless Carrier is changed.	  */
	if is_scac <>"" then
		//msg("SCAC: " + is_scac)
		/* dts - 02/02/06 Setting Carrier on normal Routing call
								Setting UF13 if this is a Carrier Prioritized Picking Call */
		if is_UpdateOrder = 'UF8' then
			idw_dm.SetItem(1, "Carrier", is_scac)
		else //is_UpdateOrder = 'UF13'
			idw_dm.SetItem(1, "User_field13", is_scac)
			idw_dm.SetItem(1, "User_field14", string(id_PreviousWgt))
		end if
		w_do.ib_changed = true
	end if
	
	//ls_3rdParty = is_Name + "  " + is_City + "  " + is_Zip + "  " + is_State + "  " + is_Cntry
	//dts 11/18/04 - Added Street Address and Carriage Returns
	//ls_3rdParty = is_Name + ", " + is_Address + ", " + is_City + ", " + is_State + "  " + is_Zip + "  " + is_Cntry
	//ls_3rdParty = is_Name + " " + char(13) + " " + is_Address + " " + char(13) + " " + is_City + ", " + is_State + "  " + is_Zip + " " + char(13) + " " + is_Cntry
	ls_3rdParty = is_Name + is_Address + is_City + is_State + is_Zip + is_Cntry
	ls_3rdPartyCR = is_Name + " " + char(13) + " " + is_Address + " " + char(13) + " " + is_City + ", " + is_State + "  " + is_Zip + " " + char(13) + " " + is_Cntry
	if is_ShipAcct <>"" or trim(ls_3rdParty) <> "" then
	/*If ShipAcct or Address is returned, Update Delivery_Notes.Note_Text as follows:
	  - 'Acct#' + ShipAcct +', 3RD PARTY BILL: ' + city/state/zip, separated by 2 spaces (where project_id, do_no...)
    - Delete any existing 'BL' Delivery Notes for selected Order		*/

		if is_ShipAcct <> "" then
		  ls_DelNote = "Acct#: " + is_ShipAcct 
		end if
		if trim(ls_3rdParty) <> "" then 
			//ls_3rdParty = "3RD PARTY BILL: " +	is_Name + "  " + is_City + "  " + is_State + "  " + is_Zip + "  " + is_Cntry
			//ls_3rdParty = "3RD PARTY BILL: " +	ls_3rdParty
			ls_3rdParty = "3RD PARTY BILL: " +	ls_3rdPartyCR // 09/25/06
			msg("3rd-Party: " + ls_3rdParty)
			if is_ShipAcct <> "" then
				ls_DelNote = ls_DelNote + ", " + ls_3rdParty
			//dts 9/29/04 - added 'else' block here (for when Acct# is not present)
			else
				ls_DelNote = ls_3rdParty
			end if			
			
			/*dts (11/10/04) 3rd-party billing from LMS Socket Call isn't printing on BOL
			  BOL Special instructions are being printed from DM.PackList_Notes
			  If Terms Code is 11 (per D. Ely), put 3rd-party billing info in dm.packlist_notes
			  Need to avoid saving 3rd-Party info multiple times (successive socket calls)
			   - Placing a '|' at end of 3rd-Party info to strip it out on successive calls.
			*/
			//if idw_dm.GetItemString(1, "User_Field1") = '11' then
			//dts - 07/20/05 - added condition for Terms Code '18' for 3rd-party billing.
			
			//11/05 - PCONKL - Going to Terms code table to determine pulling the 3rd party billing info instead of hardcoding
			lswarehouse = w_do.idw_main.GetItemString(1,'wh_Code')
			lsTermCode = idw_dm.GetItemString(1, "User_Field1")
			
			Select use_route_bill_addr_ind into :lsRouteInd
			From Terms_Codes
			Where Project_id = :gs_Project and wh_code = :lsWarehouse and terms_code = :lsTermCode;
			
			If lsRouteInd = 'Y' Then
			//if idw_dm.GetItemString(1, "User_Field1") = '11' or idw_dm.GetItemString(1, "User_Field1") = '18' then
			// What about successive calls?  We could be stringing 3rd Party info multiple times...	
			   ls_PLNotes = idw_dm.GetItemString(1, "PackList_Notes")
				if isnull(ls_PLNotes) then
					idw_dm.SetItem(1, "PackList_Notes", ls_3rdParty + " | ")
				else
					ll_Pos = Pos(ls_PLNotes, "3RD PARTY BILL")
					if ll_Pos > 0 then
						ll_Pos = Pos(ls_PLNotes, " | ")
						if ll_pos > 0 then
							ls_PLNotes = mid(ls_PLNotes, ll_Pos + 3)
						end if
					end if
					idw_dm.SetItem(1, "PackList_Notes", ls_3rdParty + ' | ' + ls_PLNotes)
				end if
			end if						
		end if		

		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

		delete from Delivery_Notes 
		where Project_ID = :gs_project and DO_NO = :w_do.is_dono and Note_Type = 'BL'
		Using SQLCA;			
	
		msg("Project: " + gs_project +", " +w_do.is_dono + char(13) + ls_DelNote)
		insert into Delivery_Notes (Project_ID, DO_NO, Note_Type, Note_Text, note_seq_no)
		values (:gs_project, :w_do.is_dono, 'BL', :ls_DelNote, 1)
		Using SQLCA;			
			
		If sqlca.sqlcode <> 0 Then
			ls_ErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "Rollback" using SQLCA;
			Messagebox(is_Title, "Unable to create new Delivery Note!~r~r" + ls_ErrText)
			Return
		End If
	
		Execute Immediate "Commit" Using Sqlca;
		If sqlca.sqlcode <> 0 Then
			MessageBox(is_title,"Unable to Commit Delivery Notes changes!")
			Return 
		End If
	end if

else
	//For Rating
	if is_LineHaul <> "" then
		msg ("About to SetItem 'Freight_Cost': " + is_LineHaul)
	  	idw_dm.SetItem(1, "Freight_Cost", double(is_LineHaul))
		w_do.ib_changed = true
	end if
end if

if w_do.ib_changed then
  //messagebox(is_title, "Order updated with " + is_RouteRate + " info.")
	ls_msg = "Order updated with " + is_RouteRate + " info."
	if is_RouteRate = 'Routing' then
		if is_UpdateOrder = "UF13" then
			ls_msg = "Carrier Retrieved for Prioritized Picking."
		end if
		//st_msg.text += " (Carrier, User_Field8)
	else
		ls_msg = "Order updated with " + is_RouteRate + " info."
		ls_msg += " (Rate=" + is_LineHaul +")"		
	end if
end if
wf_BigMsgBox (ls_Msg) 
end subroutine

public subroutine wf_setaddr (string as_addr_type);
//messagebox ("wh", ls_WHCode)

if as_Addr_Type = "SF" then //Ship From
	SELECT City, Zip, State, Country
	INTO :is_SFCity, :is_SFZip, :is_SFState, :is_SFCntry
	FROM warehouse
	WHERE wh_code=:is_WHCode;
else //Ship To
	/* TEMP - Should ShipTo <Code> be DAA.Name if 'IT' record present? */
	/* 02/12/04 - Using User_Field2 (Sold To) if present...  */
	if isnull(idw_dm.GetItemString(1, 'User_Field2')) then
		is_STCode = idw_dm.GetItemString(1, 'Cust_code')
		msg("CustCode: " + idw_dm.GetItemString(1, 'Cust_code'))
	else
		is_STCode = idw_dm.GetItemString(1, 'User_Field2')
		msg("SoldTo(UF2): " + idw_dm.GetItemString(1, 'User_Field2'))
	end if
	SELECT City, Zip, State, Country
	INTO :is_STCity, :is_STZip, :is_STState, :is_STCntry
	FROM delivery_alt_address
	WHERE project_id=:gs_project and do_no=:w_do.is_dono and Address_Type='IT';
	if isnull(is_STCity) or is_STCity="" then
		//messagebox ("wf_SetAddr", "Setting SF Addr to Delivery Master fields...")
		//set SF variables to values from Delivery Master
		is_STCity = idw_dm.GetItemString(1, 'City')
		is_STState = idw_dm.GetItemString(1, 'State')
		is_STZip = idw_dm.GetItemString(1, 'Zip')
		is_STCntry = idw_dm.GetItemString(1, 'Country')
	end if	
end if
//messagebox ("X-City-X", "X-" + is_STCity +"-X")
//messagebox ("zip,state,cntry", is_SFZip +", " + is_SFState +", " + is_SFCntry)
return
end subroutine

public subroutine wf_writexml ();OleObject dom, Root, common, Node, WMSRate, ShipFrom, ShipTo, AddressInfo, ShipInfo, Product, ProductInfo
double ld_Wgt
string ls_ShipDate, ls_msg

//get wgt for each line (from Item Master) and sum
ld_Wgt = wf_GetWeight()
//messagebox("Total Wgt", string(ld_Wgt))

if ld_Wgt=0 then
	if is_RouteRate = "Routing" then
		ls_msg = "Error!  Weight must be set up in Item Master."
	else
		ls_msg = "Error!  No Weights identified on Packing List."
	end if
	messagebox(is_title, ls_msg)
	wf_BigMsgBox(ls_msg)
	return
end if

//2/14/06 - comparing weight to previous call from Carrier Prioritized Pick
if ld_Wgt = id_PreviousWgt then
	//! if the message below changes, (may have to) change condition in ole_dssocket.ocx_connect
	ls_msg = "Retrieved Carrier not updated. Weight has not changed."
	//messagebox(is_title, ls_msg)
	wf_BigMsgBox(ls_msg)
	return
else
	id_PreviousWgt = ld_Wgt
end if

/* dts - 02/02/06 added Carrier Prioritized picking call (from PickList print)
			- not setting UF8 in that case */
if is_UpdateOrder = 'UF8' then 
	//Store Original Carrier into User_Field8
	//if isnull(is_Userfield8) then
	if isnull(is_Userfield8) or is_Userfield8 = "" then
	  idw_dm.SetItem(1, "User_Field8", is_Carrier)
	else
	  //messagebox("UF 8", w_do.idw_main.GetItemString(1,"User_field8"))
	end if
//elseif is_UpdateOrder = 'UF13' then
//Requirements state to NOT update UF13 with Original Carrier
//	idw_dm_other.SetItem(1, "User_Field13", is_Carrier)
end if
wf_SetAddr("SF")

wf_SetAddr("ST")
//messagebox ("ShipFrom City, zip,state,cntry", is_SFCity + ", " + is_SFZip +", " + is_SFState +", " + is_SFCntry)
//messagebox ("ShipTo City, zip,state,cntry", is_STCity + ", " + is_STZip +", " + is_STState +", " + is_STCntry)

dom = Create OLEObject
if dom.ConnecttoNewObject ("MSXML2.DOMDocument.6.0") <> 0 then	//ET3 2013-02-18: change per MS for Win7
//if dom.ConnecttoNewObject ("MSXML2.DOMDocument") <> 0 then  //ET3 2012-10-18: Generalized XML versioning
//if dom.ConnecttoNewObject ("MSXML2.DOMDocument.4.0") <> 0 then
	MessageBox (is_title, "Error - Can't create XML DOM object!")
	wf_BigMsgBox ("Error - Can't create XML DOM object!")
	return
end if

dom.async = false;
//?xmlDoc.resolveExternals = false;
//?xmlDoc.PreserveWhitespace = true;
//xmlDoc.loadXML("<root/>");
/*if (xmlDoc.parseError.errorCode <> 0) {
   var myErr = xmlDoc.parseError;
   alert("You have error " + myErr.reason);
} else {*/


 // Create a processing instruction targeted for xml.
Node = dom.CreateProcessingInstruction("xml", "version='1.0'")
dom.appendChild (Node)
 //Node = null //Set Node = Nothing
 
 // Create a processing instruction targeted for xml-stylesheet.
// Set Node = dom.createProcessingInstruction("xml-stylesheet", "type='text/xml' href='test.xsl'")
// dom.appendChild Node
 
// Create a comment for the document.
//Node = dom.createComment("SIMS-LMS Routing Call; xml file created using XML DOM object.")
//dom.appendChild (Node)

// Create the root element LMSRequest.
root = dom.CreateElement("LMSRequest")
// Add the root element to the DOM instance.
dom.AppendChild (root)

//Create a text element.
common = dom.CreateElement("Common")
root.appendChild (common)

Node=Dom.CreateElement("RequestType")
common.AppendChild (Node)
Node.Text = "WMSRATE"

Node=Dom.CreateElement("Client")
common.AppendChild (Node)
Node.Text = "420" //LMS Customer Number

Node=Dom.CreateElement("RatingGroup")
common.AppendChild (Node)
Node.Text = " "

Node=Dom.CreateElement("Authorization")
common.AppendChild (Node)
// Node.Text = "110002389"
//Node.Text = "0007332001" //TEMP - Shipment #?  DO_NO?
if isnull(is_Userfield6) or is_Userfield6 = "" then
//LMS Stores 9 characters so trim to 9 (Right-most) before sending)
	node.text = right(w_do.is_dono, 9)
else
	node.text = is_UserField6
end if
// 02/04/04 node.text = right(w_do.is_dono, 9)

WMSRate = dom.CreateElement("WMSRATE")
root.AppendChild (WMSRate)

//Ship From Addr. info... 
ShipFrom = dom.CreateElement("ShipFrom")
WMSRate.AppendChild (ShipFrom)

AddressInfo = dom.CreateElement("AddressInfo")
ShipFrom.AppendChild (AddressInfo) 

Node=Dom.CreateElement("Code")
AddressInfo.AppendChild (Node)
//Node.Text = "NASHVILLE"  //TEMP - Grab WH_Code...
Node.Text = is_WHCode

//5/18/05 - added 'NoNull' call to ShipFrom data elements
Node=Dom.CreateElement("Country")
AddressInfo.AppendChild (Node)
Node.Text = NoNull(is_SFCntry)

Node=Dom.CreateElement("City")
AddressInfo.AppendChild (Node)
Node.Text = NoNull(is_SFCity)

Node=Dom.CreateElement("State")
AddressInfo.AppendChild (Node)
Node.Text = NoNull(is_SFState)
if upper(left(is_SFCntry, 2)) <> "US" then Node.Text = is_SFCntry

Node=Dom.CreateElement("Zip")
AddressInfo.AppendChild (Node)
Node.Text = NoNull(is_SFZip)


//Now, Ship To info:
ShipTo = dom.CreateElement("ShipTo")
WMSRate.AppendChild (ShipTo)

AddressInfo = dom.CreateElement("AddressInfo")
ShipTo.AppendChild (AddressInfo) 

Node=Dom.CreateElement("Code")
AddressInfo.AppendChild (Node)
//Bill-To Code from 3COM
//Only really important on routing
//DM.Cust_Code
//Node.Text = "0007332001" 
Node.text = is_STCode

//dts - 9/24/04 - Adding Ship To Code (from Delivery Master Cust_Code)
Node=Dom.CreateElement("ShipToCode")
AddressInfo.AppendChild (Node)
Node.text = NoNull(idw_dm.GetItemString(1, 'cust_code'))

Node=Dom.CreateElement("Country")
AddressInfo.AppendChild (Node)
Node.Text = NoNull(is_STCntry)

Node=Dom.CreateElement("City")
AddressInfo.AppendChild (Node)
Node.Text = NoNull(is_STCity)

Node=Dom.CreateElement("State")
AddressInfo.AppendChild (Node)
Node.Text = NoNull(is_STState)
if upper(left(is_STCntry, 2)) <> "US" then Node.Text = NoNull(is_STCntry)

Node=Dom.CreateElement("Zip")
AddressInfo.AppendChild (Node)
Node.Text = NoNull(is_STZip)


//Add Ship Info section
ShipInfo = dom.CreateElement("ShipInfo")
WMSRate.AppendChild (ShipInfo)

Node=Dom.CreateElement("RateType")
ShipInfo.AppendChild (Node)
if is_RouteRate='Routing' then
	Node.Text = "CA"
else //Rating
	Node.Text = "CL"
end if
 
ls_ShipDate= string(idw_dm.GetItemDateTime(1, 'Schedule_Date'), "mm/dd/yyyy")
if ls_ShipDate = "" then
	ls_ShipDate= string(now(), "mm/dd/yyyy")
end if
//messagebox("ShipDateTime", ls_ShipDate)
Node=Dom.CreateElement("ShipDate")
ShipInfo.AppendChild (Node)
Node.text = ls_ShipDate
//Node.Text = "01-30-2004"

Node=Dom.CreateElement("Scac")
ShipInfo.AppendChild (Node)
if is_RouteRate='Routing' then
	/*UF8 is Set from Carrier on first Route Request so that subsequent Route requests will use the original Carrier	
	 ?02/02/06 - What should we use for Prioritized Picking call???  
	 	- Using whatever is currently stored in Carrier field */
	if is_UpdateOrder = 'UF8' then
		Node.text = NoNull(idw_dm.GetItemString(1, 'User_Field8'))
	else
		Node.text = NoNull(idw_dm.GetItemString(1, 'Carrier'))
	end if
else //Rating
	Node.text = NoNull(idw_dm.GetItemString(1, 'Carrier')) //User_Field8
end if

Node=Dom.CreateElement("InOut")
ShipInfo.AppendChild (Node)
Node.Text = "Out"

Node=Dom.CreateElement("Mode")
ShipInfo.AppendChild (Node)
Node.Text = " "

Node=Dom.CreateElement("Service")
ShipInfo.AppendChild (Node)
Node.Text = " "

Node=Dom.CreateElement("Equipment")
ShipInfo.AppendChild (Node)
Node.Text = " "

/*dts - 07/30/07 - Adding Carton Count element...
(actually interested in Pallet Count, but grabbing 
carton count without regard to carton type as directed by LMS) */
Node=Dom.CreateElement("CartonCount")
ShipInfo.AppendChild (Node)
if is_RouteRate='Routing' then
	Node.Text = " "
else //Rating
	Node.Text = il_CartonCount
end if

//Add Product section
Product = dom.CreateElement("Product")
WMSRate.AppendChild (Product)

ProductInfo = dom.CreateElement("ProductInfo")
Product.AppendChild (ProductInfo)

Node=Dom.CreateElement("Class")
ProductInfo.AppendChild (Node)
Node.Text = "92.5"  //Default for 3COM

Node=Dom.CreateElement("Weight")
ProductInfo.AppendChild (Node)
Node.Text = ld_wgt

Node=Dom.CreateElement("WeightUom")
ProductInfo.AppendChild (Node)
//should check Standard_Of_Measure in Project_Warehouse to determine English/Metric...
Node.Text = "LB"  //for now, Defaulting to LB and changing if rb_metric is checked
if w_do.tab_Main.tabPage_Pack.rb_metric.checked = true then
	Node.Text = "KG"
end if

Node=Dom.CreateElement("Volume")
ProductInfo.AppendChild (Node)
Node.Text = " "

Node=Dom.CreateElement("VolumeUom")
ProductInfo.AppendChild (Node)
Node.Text = " "

 
//Save the XML document to a file.
//dom.save App.Path + "\dynamDom.xml"

msg(string(dom.xml))
mle_send.text=string(dom.xml)
 
// root = null
// dom = null
    
return

end subroutine

public function boolean wf_connect ();//Need to get host/port from ini file (and set text boxes on Open to allow for debug efforts)
ole_dssocket.object.remotehost = sle_remotehost.text
ole_dssocket.object.remoteport = sle_remoteport.text

//establish connection...
//(Need to trap success/failure!)
ole_dssocket.object.action=2 
return true
end function

public function double wf_getweight ();integer li_rowcount, li
string lsSKU, lsSpl
double ldQTY, ldWgt, ldSum
datawindow ldw

if is_RouteRate = 'Routing' then
	
	ldw = w_do.tab_main.tabpage_pick.dw_pick
	li_rowcount = ldw.rowcount()
	
	msg ("Rows: " + string(li_RowCount))
	for li = 1 to li_rowcount
		
		// 08/04 - PCONKL - Ignore component children that are already accounted for in the Parent's weight
		//If ldw.GetItemString(li, 'component_ind') <> 'Y' and  ldw.GetItemString(li, 'component_ind') <> 'N' Then COntinue
		// dts - 10/05/04 - Now looking expressly for 'D's and 'W's (so '' won't be affected)
		If ldw.GetItemString(li, 'component_ind') = 'D' or ldw.GetItemString(li, 'component_ind') = 'W' Then Continue
		
		lsSku = ldw.GetItemString(li, 'SKU')
		lsSpl = ldw.GetItemString(li, 'Supp_code')
		ldQty = ldw.GetItemNumber(li, 'Quantity')
		//messagebox(gs_project, lsSKU + ", " + lsSpl + ", " + string(ldQty))
		// 02/10/06 - For Carrier Prioritized Picking, using Packaged wgt first (weight_1)
		//		and then Unpackaged Wgt (actually, UF2) if Packaged is 0
		//		(doing this whether this is the normal Routing call or the call from Pick list (for Carrier Prioritized Picking))
		
		//		SELECT weight_1
		
		
		SELECT case when weight_1 > 0
		then weight_1
		else 
			//UF2 is Unpackaged Wgt on Item Master screen
		  case when IsNumeric(user_field2)=1
		  then cast(user_field2 as decimal)  // '6.' was causing an error, so now 'cast'-ing uf2
		  else 0
		  end
		end
		INTO :ldWGT
		FROM Item_Master
		WHERE project_id=:gs_project and SKU=:lsSKU and supp_code=:lsSpl;
		CHOOSE CASE SQLCA.SQLCode
			CASE 0 
				//messagebox ("After in-line SQL","All Ok")	
				if isnull(ldwgt) or ldWgt = 0 then
					//messagebox ("Zero","ldWgt=0")
					//ldsum = ldsum + 1 //TEMP - comment out this line for hard stop when weight = 0
				else
					//messagebox("Wgt", string(ldWgt))	
					ldSum = ldSum + (ldWgt * ldQty)
				end if
				//messagebox("ldsum",string(ldsum))
			CASE 100
			 // not found
			 //messagebox ("After in-line SQL","Not Found")
			CASE ELSE
			 // error
			 messagebox (is_title, "wf_GetWeight In-line SQL Error!")	
		END CHOOSE	
	next
else
	ldw = w_do.tab_main.tabpage_pack.dw_pack
	ldSum = ldw.GetItemNumber(1, "c_weight")
	/* dts - 5/18/04 - Items packed in the same container each have the total gross weight in Weight_Gross
	 - Now just grabbing the weight from 'c_weight on the Packing data window
	li_rowcount = ldw.rowcount()
	for li = 1 to li_rowcount
		ldWgt = ldw.GetItemNumber(li, 'weight_gross')
		if isnull(ldwgt) or ldWgt = 0 then
			//messagebox ("Zero","ldWgt=0")
			//ldsum = ldsum + 1 //TEMP - comment out this line for hard stop when weight = 0
		else
			//messagebox("Wgt", string(ldWgt))	
			ldSum = ldSum + ldWgt
		end if
	next */
	/* 8/14/07 - now passing carton count to LMS */ 
	il_CartonCount = ldw.GetItemNumber(1, "c_carton_count")
	msg("Carton Count: " + string(il_CartonCount))
end if

msg("Total Wgt: " + string(ldSum))
return ldSum
end function

public subroutine msg (string as_msg);if ib_debug then
  messagebox("Debug Message", as_msg)
//should allow user to switch Debug off with a response...
end if
end subroutine

on w_dssocket.create
this.cb_ok=create cb_ok
this.cbx_debug=create cbx_debug
this.cb_runall=create cb_runall
this.cb_1=create cb_1
this.st_4=create st_4
this.st_3=create st_3
this.mle_send=create mle_send
this.st_msg=create st_msg
this.cb_writexml=create cb_writexml
this.cb_6=create cb_6
this.cb_test=create cb_test
this.cb_readxml=create cb_readxml
this.cb_3=create cb_3
this.ole_dssocket=create ole_dssocket
this.cb_send=create cb_send
this.mle_output=create mle_output
this.sle_remoteport=create sle_remoteport
this.st_2=create st_2
this.st_1=create st_1
this.sle_remotehost=create sle_remotehost
this.cb_connect=create cb_connect
this.rr_1=create rr_1
this.ln_1=create ln_1
this.Control[]={this.cb_ok,&
this.cbx_debug,&
this.cb_runall,&
this.cb_1,&
this.st_4,&
this.st_3,&
this.mle_send,&
this.st_msg,&
this.cb_writexml,&
this.cb_6,&
this.cb_test,&
this.cb_readxml,&
this.cb_3,&
this.ole_dssocket,&
this.cb_send,&
this.mle_output,&
this.sle_remoteport,&
this.st_2,&
this.st_1,&
this.sle_remotehost,&
this.cb_connect,&
this.rr_1,&
this.ln_1}
end on

on w_dssocket.destroy
destroy(this.cb_ok)
destroy(this.cbx_debug)
destroy(this.cb_runall)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.mle_send)
destroy(this.st_msg)
destroy(this.cb_writexml)
destroy(this.cb_6)
destroy(this.cb_test)
destroy(this.cb_readxml)
destroy(this.cb_3)
destroy(this.ole_dssocket)
destroy(this.cb_send)
destroy(this.mle_output)
destroy(this.sle_remoteport)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_remotehost)
destroy(this.cb_connect)
destroy(this.rr_1)
destroy(this.ln_1)
end on

event open;string ls_PreviousWgt

//size the window to show only the message section (and hide the debug section)
this.width = rr_1.width * 1.1
this.height = rr_1.height * 1.3

//dts - 02/02/06 is_RouteRate = message.StringParm  //accept the 'Routing' or 'Rating' parameter
istrParms = message.PowerObjectParm
is_RouteRate = istrparms.String_Arg[1] 
is_UpdateOrder = istrParms.String_Arg[2] // either UF8 (normal routing) or UF13 (Carrier Prioritized Picking)
ls_PreviousWgt = istrParms.String_Arg[3] // wgt from previous call(Carrier Prioritized Picking)
//if ls_PreviousWgt > '0' then
if IsNumber(ls_PreviousWgt) then
	id_PreviousWgt = Dec(ls_PreviousWgt)
end if

/*Get Connection Info (Host/Port) from INI File
  - Test: lmstapp.menlolog.com / 1050
	- Prod: lmsaaapp.menlolog.com / 1050				*/
sle_RemoteHost.text = ProfileString(gs_inifile,"LMS","RemoteHost","")
sle_RemotePort.text = ProfileString(gs_inifile,"LMS","RemotePort","")

is_title = "LMS " + is_RouteRate + " Call"
this.title = is_title
st_msg.text = "Connecting to LMS for " + is_RouteRate + " Information."
cb_WriteXML.Text = "Write " + is_RouteRate + " Request"
timer(1)

idw_dm = w_do.tab_main.tabpage_main.dw_main
idw_dm_other = w_do.tab_main.tabpage_other.dw_other // dts - 02/10/06 (Carrier Prioritized Picking)

is_WHCode = idw_dm.GetItemString(1, 'WH_Code')
is_Carrier = idw_dm.GetItemString(1, 'Carrier')
is_UserField6 = w_do.idw_main.GetItemString(1,"User_field6") //<Authorization> in LMS Calls
is_UserField8 = w_do.idw_main.GetItemString(1,"User_field8") //Persistent Carrier Routing Code. Stored for successive Routing Calls
//messagebox ("XX", w_do.tab_main.tabpage_pack.dw_pack.c_weight)
//messagebox ("XX", w_do.tab_main.tabpage_pack.c_weight)

this.show()

if gs_userid = "DTS" then
	cb_test.visible = true
	if messagebox ("Hi Dave", "Run Scripts now?", Exclamation!, YesNo!, 1) = 2 then
		return
	end if
end if

//dts - 5/19/04 -added check to make sure connection info is in ini file...
if sle_RemoteHost.text = '' then
	messagebox (is_Title,"LMS Connection info (RemoteHost and RemotePort) not in INI file.")
	st_msg.text = "LMS Connection info not in INI file. Can't Connect!"
	cb_ok.visible = true
	cb_ok.text = "&Close"
	return
end if

wf_RunAll()

//ole_dssocket.object.action=1 //close connection
//close 



end event

event doubleclicked;//back door to LMS Connection debugging tools
// - hold <shift> key while double-clicking to expose.
if flags = 5 then
	this.event ue_ShowDebugTools()
end if

end event

event timer;if cb_OK.visible = true then
	st_msg.textcolor=rgb(0, 0, 0)
else
	ii_color = abs(ii_color - 255)
	st_msg.textcolor=rgb(ii_color, ii_color, ii_color)
end if
end event

event close;//messagebox("Close","Disconnect here.  Anything else?")
//ole_dssocket.object.action=1 //close connection
end event

type cb_ok from commandbutton within w_dssocket
boolean visible = false
integer x = 590
integer y = 452
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Ok"
end type

event clicked;close(parent)
end event

type cbx_debug from checkbox within w_dssocket
integer x = 1975
integer y = 176
integer width = 709
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show Debug Messages"
end type

event clicked;ib_Debug = not ib_Debug 
msg("Debug On")
end event

type cb_runall from commandbutton within w_dssocket
integer x = 3273
integer y = 284
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Run All"
end type

event clicked;wf_RunAll()

end event

type cb_1 from commandbutton within w_dssocket
integer x = 3282
integer y = 1660
integer width = 407
integer height = 112
integer taborder = 140
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update Order"
end type

event clicked;wf_UpdateOrder()

end event

type st_4 from statictext within w_dssocket
integer x = 1906
integer y = 44
integer width = 1833
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "LMS Connection Tools"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_3 from statictext within w_dssocket
integer x = 1970
integer y = 1160
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Response:"
boolean focusrectangle = false
end type

type mle_send from multilineedit within w_dssocket
integer x = 1970
integer y = 408
integer width = 1714
integer height = 400
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_msg from statictext within w_dssocket
integer x = 119
integer y = 212
integer width = 1362
integer height = 160
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Connecting to LMS for Routing/Rating Information"
boolean border = true
borderstyle borderstyle = styleshadowbox!
end type

type cb_writexml from commandbutton within w_dssocket
integer x = 1970
integer y = 284
integer width = 654
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Write Request"
end type

event clicked;wf_WriteXML()

/*
OleObject dom, Root, common, Node, WMSRate, ShipFrom, ShipTo, AddressInfo, ShipInfo, Product, ProductInfo
double ld_Wgt

//get wgt for each line (from Item Master) and sum
ld_Wgt = wf_GetWeight()
//messagebox("Total Wgt", string(ld_Wgt))

if ld_Wgt=0 then
	messagebox("LMS Call", "Error!  Weight must be set up in Item Master.")
	return
end if

//Store Original Carrier into User_Field8
//if isnull(is_Userfield8) then
if isnull(is_Userfield8) or is_Userfield8 = "" then
  idw_dm.SetItem(1, "User_Field8", is_Carrier)
else
  //messagebox("UF 8", w_do.idw_main.GetItemString(1,"User_field8"))
end if

wf_SetAddr("SF")

wf_SetAddr("ST")
//messagebox ("ShipFrom City, zip,state,cntry", is_SFCity + ", " + is_SFZip +", " + is_SFState +", " + is_SFCntry)
//messagebox ("ShipTo City, zip,state,cntry", is_STCity + ", " + is_STZip +", " + is_STState +", " + is_STCntry)

dom = Create OLEObject
if dom.ConnecttoNewObject ("MSXML2.DOMDocument.6.0") <> 0 then	//ET3 2013-02-18: change per MS for Win7
	//if dom.ConnecttoNewObject ("MSXML2.DOMDocument.4.0") <> 0 then
	MessageBox ("Error", "Can't create XML DOM object!")
	return
end if

dom.async = false;
//?xmlDoc.resolveExternals = false;
//?xmlDoc.PreserveWhitespace = true;
//xmlDoc.loadXML("<root/>");
/*if (xmlDoc.parseError.errorCode <> 0) {
   var myErr = xmlDoc.parseError;
   alert("You have error " + myErr.reason);
} else {*/


 // Create a processing instruction targeted for xml.
Node = dom.createProcessingInstruction("xml", "version='1.0'")
dom.appendChild (Node)
 //Node = null //Set Node = Nothing
 
 // Create a processing instruction targeted for xml-stylesheet.
// Set Node = dom.createProcessingInstruction("xml-stylesheet", "type='text/xml' href='test.xsl'")
// dom.appendChild Node
 
 // Create a comment for the document.
//Node = dom.createComment("SIMS-LMS Routing Call; xml file created using XML DOM object.")
//dom.appendChild (Node)
 
 // Create the root element LMSRequest.
 root = dom.createElement("LMSRequest")
 // Add the root element to the DOM instance.
 dom.appendChild (root)
 
 //Create a text element.
 common = dom.createElement("Common")
 root.appendChild (common)

 Node=Dom.createElement("RequestType")
 common.appendChild (Node)
 Node.Text = "WMSRATE"
 
 Node=Dom.createElement("Client")
 common.appendChild (Node)
 Node.Text = "420"

 Node=Dom.createElement("RatingGroup")
 common.appendChild (Node)
 Node.Text = " "

 Node=Dom.createElement("Authorization")
 common.appendChild (Node)
// Node.Text = "110002389"
  //Node.Text = "0007332001" //TEMP - Shipment #?  DO_NO?
  node.text = w_do.is_dono

 WMSRate = dom.createElement("WMSRATE")
 root.appendChild (WMSRate)

//Ship From Addr. info... 
 ShipFrom = dom.createElement("ShipFrom")
 WMSRate.appendChild (ShipFrom)

 AddressInfo = dom.createElement("AddressInfo")
 ShipFrom.appendChild (AddressInfo) 

 Node=Dom.createElement("Code")
 AddressInfo.appendChild (Node)
 Node.Text = "NASHVILLE"  //TEMP - Grab WH_Code...

 Node=Dom.createElement("Country")
 AddressInfo.appendChild (Node)
 Node.Text = is_SFCntry //"USA"

 Node=Dom.createElement("City")
 AddressInfo.appendChild (Node)
 Node.Text = is_SFCity //"Tigard"

 Node=Dom.createElement("State")
 AddressInfo.appendChild (Node)
 Node.Text = is_SFState //"OR"

 Node=Dom.createElement("Zip")
 AddressInfo.appendChild (Node)
 Node.Text = is_SFZip //"97224"

 
//Now, Ship To info:
 ShipTo = dom.createElement("ShipTo")
 WMSRate.appendChild (ShipTo)

 AddressInfo = dom.createElement("AddressInfo")
 ShipTo.appendChild (AddressInfo) 

 Node=Dom.createElement("Code")
 AddressInfo.appendChild (Node)
 //Node.Text = "0000179121"
 Node.Text = "0007332001" //TEMP - 'Name' from delivery_alt_address for type 'IT'? What if no IT addr? (Cust_Code/Name?)

 Node=Dom.createElement("Country")
 AddressInfo.appendChild (Node)
 Node.Text = is_STCntry 

 Node=Dom.createElement("City")
 AddressInfo.appendChild (Node)
 Node.Text = is_STCity

 Node=Dom.createElement("State")
 AddressInfo.appendChild (Node)
 Node.Text = is_STState

 Node=Dom.createElement("Zip")
 AddressInfo.appendChild (Node)
 Node.Text = is_STZip

 
//Add Ship Info section
 ShipInfo = dom.createElement("ShipInfo")
 WMSRate.appendChild (ShipInfo)

 Node=Dom.createElement("RateType")
 ShipInfo.appendChild (Node)
 if is_RouteRate='Routing' then
	Node.Text = "CA"
 else //Rating
	Node.Text = "CL"
 end if
 
 Node=Dom.createElement("ShipDate")
 ShipInfo.appendChild (Node)
 Node.Text = "01-30-2004"

 Node=Dom.createElement("Scac")
 ShipInfo.appendChild (Node)
 if is_RouteRate='Routing' then
   //UF8 is Set from Carrier on first Route Request so that subsequent Route requests will use the original Carrier	
	Node.text = idw_dm.GetItemString(1, 'User_Field8')
 else //Rating
	Node.text = idw_dm.GetItemString(1, 'Carrier') //User_Field8
 end if


 

 Node=Dom.createElement("InOut")
 ShipInfo.appendChild (Node)
 Node.Text = "Out"

 Node=Dom.createElement("Mode")
 ShipInfo.appendChild (Node)
 Node.Text = " "

 Node=Dom.createElement("Service")
 ShipInfo.appendChild (Node)
 Node.Text = " "

 Node=Dom.createElement("Equipment")
 ShipInfo.appendChild (Node)
 Node.Text = " "


//Add Product section
 Product = dom.createElement("Product")
 WMSRate.appendChild (Product)

 ProductInfo = dom.createElement("ProductInfo")
 Product.appendChild (ProductInfo)

 Node=Dom.createElement("Class")
 ProductInfo.appendChild (Node)
 Node.Text = "100"

 Node=Dom.createElement("Weight")
 ProductInfo.appendChild (Node)
 Node.Text = ld_wgt //"9.7"

 Node=Dom.createElement("WeightUom")
 ProductInfo.appendChild (Node)
 //should check Standard_Of_Measure in Project_Warehouse to determine English/Metric...
 Node.Text = "LB"

 Node=Dom.createElement("Volume")
 ProductInfo.appendChild (Node)
 Node.Text = " "

 Node=Dom.createElement("VolumeUom")
 ProductInfo.appendChild (Node)
 Node.Text = " "




 
//Save the XML document to a file.
 //dom.save App.Path + "\dynamDom.xml"

 messagebox("Route Request:", string(dom.xml))
 mle_send.text=string(dom.xml)
 
// root = null
// dom = null
    
return

*/
end event

type cb_6 from commandbutton within w_dssocket
integer x = 2432
integer y = 1660
integer width = 466
integer height = 112
integer taborder = 130
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Show Variables"
end type

event clicked;ShowValues()
end event

type cb_test from commandbutton within w_dssocket
boolean visible = false
integer x = 2839
integer y = 284
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Test"
end type

event clicked;if ib_Connected then
	messagebox("Connected","True")
else
	messagebox("Connected","False")
end if

if isnull(w_do.idw_main.GetItemString(1,"User_field4")) then
  messagebox("UF 4", "Null") 
elseif w_do.idw_main.GetItemString(1,"User_field4") = "" then
  messagebox("UF 4", "Empty")
else
  messagebox("UF 4", w_do.idw_main.GetItemString(1,"User_field4"))
end if

if isnull(w_do.idw_main.GetItemString(1,"User_field8")) then
  messagebox("UF 8", "Null") 
elseif w_do.idw_main.GetItemString(1,"User_field8") = "" then
  messagebox("UF 8", "Empty")
else
  messagebox("UF 8", w_do.idw_main.GetItemString(1,"User_field8"))
end if
/*
Old WriteXML Test...

/* see XML DOM Methods:
   - CreateDocumentFragment, CreateNode, CreateElement, CreateTextNode...
   - maybe InsertBefore, InsertData...
*/

OleObject XMLdoc, docFragment, Root, newElem, Child, sibling
string ls_xml

XMLDoc = Create OLEObject
if XMLDoc.ConnecttoNewObject ("MSXML2.DOMDocument.6.0") <> 0 then	//ET3 2013-02-18: change per MS for Win7
//if XMLDoc.ConnecttoNewObject ("MSXML2.DOMDocument.4.0") <> 0 then
	MessageBox ("Error", "Can't create DOM object!")
	return
end if


xmlDoc.async = false;
//?xmlDoc.resolveExternals = false;
xmlDoc.loadXML("<root/>");
/*if (xmlDoc.parseError.errorCode <> 0) {
   var myErr = xmlDoc.parseError;
   alert("You have error " + myErr.reason);
} else {*/
   docFragment = xmlDoc.createDocumentFragment()
   docFragment.appendChild(xmlDoc.createElement("node1"))
   docFragment.appendChild(xmlDoc.createElement("node2"))
   docFragment.appendChild(xmlDoc.createElement("node3"))
   messagebox ("docFragment", string(docFragment.xml))
   xmlDoc.documentElement.appendChild(docFragment)
	messagebox ("xmlDoc", string(xmlDoc.xml))

/*
The following script example creates an element called PAGES and appends it to 
an IXMLDOMNode object. It then sets the text value of the element to 400. */


//xmlDoc.async = false;
//?xmlDoc.resolveExternals = false;
xmlDoc.load("<root/>");
/*if (xmlDoc.parseError.errorCode <> 0) {
   var myErr = xmlDoc.parseError;
   alert("You have error " + myErr.reason);
} else {*/
   root = xmlDoc.documentElement;
   newElem = xmlDoc.createElement("PAGES");

   root.childNodes.item(1).appendChild(newElem); //error here - null object
   root.childNodes.item(1).lastChild.text = "400";
   messagebox ("ChildNodes(1)", string(root.childNodes.item(1).xml))
	messagebox ("xmlDoc", string(xmlDoc.xml))


return

XMLDoc.Async = false
XMLDoc.ValidateonParse = true
//XMLDoc.LoadXML ("<xmlROOT> <xmlCHILD1> Child1Text </xmlCHILD1> <xmlCHILD2> Child2Text </xmlCHILD2> </xmlROOT>")
XMLDoc.LoadXML (ls_xml)
if XMLDoc.parseError.ErrorCode <> 0 then
	MessageBox ("XML parsing error", String (XMLDoc.parseError.reason))
	Destroy XMLDoc
	return
end if

Root = XMLdoc.documentElement
MessageBox ("Root node name", String (Root.nodeName))

// PowerBuilder does not support COM Variant data type so the only way to
// scan siblings is using nextSybling function
if not IsNull (Root.firstChild) then
	Child = Root.firstChild
	MessageBox ("Child", String (Child.nodeName) + " = " + String (Child.Text))

	do while not IsNull (Child.FirstChild)
		Child = Child.FirstChild
		MessageBox ("Child2", String (Child.nodeName) + " = " + String (Child.Text)) 
	loop 

end if

if not IsNull (Root.firstChild) then
	Child = Root.firstChild
	MessageBox ("Child", String (Child.nodeName) + " = " + String (Child.Text))

	do while not IsNull (Child.nextSibling)
		Child = Child.nextSibling
		MessageBox ("Child3", String (Child.nodeName) + " = " + String (Child.Text)) 
	loop 

end if

Destroy XMLDoc
*/
end event

type cb_readxml from commandbutton within w_dssocket
integer x = 1970
integer y = 1660
integer width = 402
integer height = 112
integer taborder = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Read XML"
end type

event clicked;wf_ReadXML()

/*

//copied first 'working' parse to w_dssocket.ue_temp
//Look at SelectNodes and SelectSingleNode methods - don't we just want SCAC?

OleObject XMLdoc, Root, Child, sibling
string ls_xml
long ll_VerPos
/*strip the version (<?xml version="1.0"?> from the string before parsing...
(should do this upon receiving xml from LMS*/

ls_xml=mle_output.text
ll_VerPos=pos(ls_xml,"?>")
if ll_verPos>0 then
	ls_xml=mid(ls_xml,ll_verPos + 2)
	mle_output.text=ls_xml
end if
//ue_ParseIt should return boolean or int...
ls_xml = wf_parseit(ls_xml)
ShowValues()
if is_scac <>"" then
	//messagebox("SCAC",is_scac)
	idw_dm.SetItem(1, "Carrier", is_scac)
	w_do.ib_changed = true
end if

Destroy XMLDoc
return
*/
end event

type cb_3 from commandbutton within w_dssocket
integer x = 2432
integer y = 1004
integer width = 402
integer height = 112
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Disconnect"
end type

event clicked;ole_dssocket.object.action=1 //close connection
end event

type ole_dssocket from olecustomcontrol within w_dssocket
event ocx_connect ( )
event listen ( )
event receive ( string receivedata )
event sendready ( )
event accept ( integer socketid )
event ocx_close ( integer errorcode,  string errordesc )
event exception ( integer errorcode,  string errordesc )
event asynccomplete ( integer asynctype,  integer errorcode,  string errordesc )
integer x = 1586
integer y = 20
integer width = 128
integer height = 112
integer taborder = 60
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_dssocket.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

event ocx_connect();//messagebox("OCX_Connect","Connected: About to set ib_Connected=true")
ib_Connected = true
msg("Connected")
wf_WriteXML()
//if left(st_msg.text, 5) = "Error" then
//2/14/06 - may have 'Not calling LMS...' message returned
if left(st_msg.text, 5) = "Error" or left(st_msg.text, 9) = "Retrieved" then
	msg("Halting Scripts.")
	return
end if
if wf_ValidateRequest() then
	msg ("Validated")
	msg("Connected, calling 'SendXML'")
	wf_SendXML()
else
	msg("Not Validated")
end if


end event

event receive;if len(trim(receivedata)) > 10 then
	//messagebox(string(len(receivedata)),receivedata)
	mle_output.text = ReceiveData
		msg("Calling 'ReadXML'")
    wf_ReadXML()
		msg("Calling 'UpdateOrder'")
    wf_UpdateOrder() //(Called from wf_ReadXML?)
  //messagebox ("Receive?",ReceiveData)
end if
end event

event ocx_close;if ErrorDesc = "Socket closed" then
	msg(ErrorDesc)
else
	messagebox("Error - Sockets OCX Close", ErrorDesc)
end if

end event

event exception;messagebox("Connection Exception", errordesc)
end event

event error;messagebox("Connection Error", errortext)
end event

type cb_send from commandbutton within w_dssocket
integer x = 3278
integer y = 1004
integer width = 402
integer height = 112
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send"
end type

event clicked;wf_SendXML()

/*

string ls_data

//messagebox ("","Padding to 1024")
ls_data=mle_send.text + space(1024 - len(mle_send.text))
//messagebox("Length:",string(len(ls_data)))
ole_dssocket.object.send = ls_data
//ole_dssocket.object.action=1 //close connection

*/
end event

type mle_output from multilineedit within w_dssocket
integer x = 1970
integer y = 1228
integer width = 1714
integer height = 400
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type sle_remoteport from singlelineedit within w_dssocket
integer x = 2523
integer y = 896
integer width = 279
integer height = 80
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_dssocket
integer x = 2523
integer y = 832
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Remote Port"
boolean focusrectangle = false
end type

type st_1 from statictext within w_dssocket
integer x = 1979
integer y = 832
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Remote Host"
boolean focusrectangle = false
end type

type sle_remotehost from singlelineedit within w_dssocket
integer x = 1979
integer y = 896
integer width = 526
integer height = 80
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_connect from commandbutton within w_dssocket
integer x = 1979
integer y = 1004
integer width = 402
integer height = 112
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Connect"
end type

event clicked;wf_Connect()

/*
ole_dssocket.object.remotehost = sle_remotehost.text
ole_dssocket.object.remoteport = sle_remoteport.text

//establish connection...
ole_dssocket.object.action=2 

*/
end event

type rr_1 from roundrectangle within w_dssocket
integer linethickness = 1
long fillcolor = 16777215
integer x = 59
integer y = 36
integer width = 1481
integer height = 588
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_dssocket
integer linethickness = 3
integer beginx = 1751
integer beginy = 40
integer endx = 1751
integer endy = 1800
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Dw_dssocket.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Dw_dssocket.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
