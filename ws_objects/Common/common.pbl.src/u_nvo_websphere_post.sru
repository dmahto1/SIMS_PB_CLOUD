$PBExportHeader$u_nvo_websphere_post.sru
$PBExportComments$Post a URL Transaction to Websphere
forward
global type u_nvo_websphere_post from internetresult
end type
end forward

global type u_nvo_websphere_post from internetresult
end type
global u_nvo_websphere_post u_nvo_websphere_post

type prototypes
Function Boolean SetTimeouts (ref long ResolveTimeout, ref Long ConnectTimeOut, ref Long SendTimeOut, ref long ReceiveTimeout) Library "Winhttp.dll"  Alias for "SetTimeoutsA"
end prototypes

type variables
inet	linit

Blob	ibReturnData

Boolean	ibDatabasbeenReturned
end variables

forward prototypes
public function integer internetdata (blob data)
public function string uf_request_header (string asname)
public function string uf_request_footer (string asxml)
public function string uf_post_url (string asarg)
public function string uf_get_xml_single_element (string asxml, string asfield)
public function string uf_request_header (string asname, string asattributes)
public function string uf_post_url_old (string asarg, string asurl, integer aiport)
public function string uf_post_url (string asarg, string asurl, integer aiport)
end prototypes

public function integer internetdata (blob data);
ibReturnData = data
ibDatabasbeenReturned = True

Return 0

end function

public function string uf_request_header (string asname);string	lsHeader, lsDatasource

// 10/12 - PCONKL - Add the datasource

//datasource is an optional override, may be present in the database or the .ini file. may not be present at all
lsDatasource = ProfileString(gs_inifile,"WEBSPHERE","datasource","")
If isnull(lsDatasource) or lsDatasource = '' Then
	lsDatasource = g.isWebsphereDatasource
End IF

If isnull(lsDatasource) Then lsDAtasource = ""

lsHeader = '<?xml version="1.0" encoding="UTF-8"?>'
lsHeader += '<SIMSMessage xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="Q:\xml_docs\Schema\SimsServicesV1.xsd">'
lsHeader += '<SIMSRequest name="' + asName + '" '

//Add servername and database name to header - server will verify that they are connected to the same database as client
lsHeader += 'server="' + sqlca.servername + '" database="' + sqlca.database + '" UserID="'+ gs_userid + '" dataSource="'+ lsDatasource + '"'

lsHeader += ">"


lsheader += "<" + asName + ">"

Return lsheader
end function

public function string uf_request_footer (string asxml);
String	lsFooter, lsNameLit
Long	llbeginPos, llEndPos

//add an end segment for the "name=", we would have created a beginning segment in the header
lsNameLit = '<SIMSRequest name="'
llbeginPos = pos(asXml,lsNameLit)
llEndPos = pos(asXml,'"',(llBeginPos + len(lsNameLit))) 

If llBeginPos > 0 and llEndPos > 0 Then
	lsFooter = "</" + Mid(asXML,(llbeginPos + Len(lsNameLit)),(llEndPos - (llBeginPos + Len(lsNameLit)))) + ">"
End If

lsFooter += "</SIMSRequest></SIMSMessage>"

Return asXML + lsFooter
end function

public function string uf_post_url (string asarg);
Blob	lbData
Long	llLength, llPos
Long	llTimeOut, llStatusCode
Integer	liRC, liPort, liFileNo
String	lsHeader, lsURL, lsReturn, lsXML, lsStatusText, lsREsponse
OleObject	loo_xmlhttp

//07/09 - PCONKL - PostURL now timing out with upgraded IE7. Switched to OLE Call.
// 08/09 - PCONKL -If this fails, use the original POSTURL call

//linit = Create Inet
//This.GetContextService("Internet", linit)


llTimeOut = 1000000


//lsXML = asARg

////we need to fix any "&" characters (i.e. K&N)
//llPos = Pos(lsXml,"&",1)
//Do While llPos > 0
//	
//	lsXml = Replace(lsXML,llPos,1,"&amp;")
//	llPos +=3
//	If llPos > Len(lsXml) Then
//		llPOs = 0
//	Else
//		llPos = Pos(lsXml,"&",llPos)
//	End If
//	
//Loop
//
//lllength = Len(lsXML)
//
//lsHeader = "Content-Length: " & 
//   + String(lllength) + "~n~n"
//
//
//SetNull(ibReturnData )
//ibDatabasbeenReturned = False
//
//SetPointer(Hourglass!)

//get the URL and Port from the Database - check ini file first for override

lsurl = ProfileString(gs_inifile,"WEBSPHERE","url","")
liPort = long(ProfileString(gs_inifile,"WEBSPHERE","port",""))

//If not present, get from DB
If lsurl = "" Then
	
	lsURL = g.isWebsphereUrl
	liPort = g.ilwebspherePort
	
End If

Return uf_post_url(asArg, lsURL, liPort)

//If  lsURL = "" Then
//	return "Unable to obtain Application Server connection URL information!"
//End If
//
//If liPort <=0 Then
//	return "Unable to obtain Application Server connection port information!"
//End If
//
//
////liRC = linit.PostURL  (lsURL, blob(lsXML), lsHeader, liPort, This)
//
//
//loo_xmlhttp = Create OLEobject
//loo_xmlhttp.ConnectTonewObject("MSXML2.ServerXMLHTTP.4.0")
//loo_xmlhttp.SetTimeOuts(30000,30000,600000000,600000000)
//loo_xmlhttp.Open ("POST",lsUrl,False)
////loo_xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
//loo_xmlhttp.setRequestHeader("Content-Length", lsHeader)
//
//Try
//	loo_xmlhttp.Send(lsXML)
//Catch (RuntimeError er)
//	//Messagebox("Websphere Error",String(er))
//	loo_xmlhttp.DisconnectObject()
//	Return uf_post_url_old(asArg) /*** If the new call fails, use the original call*/
//Finally
//	
//End Try
//
//llStatusCode = loo_xmlhttp.Status
//lsStatusText = String(llStatusCode) + "-" + loo_xmlhttp.StatusText
//
//If llStatusCode >= 300 Then
//	loo_xmlhttp.DisconnectObject()
//	Return lsStatusText
//End If
//
//lsResponse = loo_xmlhttp.ResponseText
//loo_xmlhttp.DisconnectObject()


//Return lsResponse

//If liRC < 1 Then 
//	
//	lsReturn = "Websphere error: (" + String(lirc) + ") - "
//	
//	Choose Case liRC
//			
//		Case -1
//			lsReturn += "General error"
//		Case -2
//			lsReturn += "Invalid URL"
//		Case -4
//			lsReturn += "Cannot connect to the Internet"
//		Case -5
//			lsReturn += "Unsupported secure (HTTPS) connection attempted"
//		Case -6
//			lsReturn += "Internet request failed~r(Probably unable to connect to server)"
//		Case else
//			lsReturn += "General error"
//	End Choose
//		
//	lsReturn += "~r~rURL= " + lsURL + "~rPort= " + String(liPort)
//	SetPointer(arrow!)
//	Return lsReturn
//	
//End If

//Wait for response from call
//Do While Not ibdatabasbeenreturned
//Loop

//lbData = ibreturndata
//
////Messagebox("",String(lbData))
//
//SetPointer(arrow!)
//
//Return String(lbData)
//

end function

public function string uf_get_xml_single_element (string asxml, string asfield);

String	lsReturnCode
long		llBeginPos, llEndPos

llBeginPos = Pos(Upper(asXML),"<" + Upper(asField) + ">")
llEndPos = Pos(Upper(asXML),"</" + Upper(asField) + ">")

If llBeginPOs = 0 or llEndPos = 0 Then Return ""

lsReturnCode = Mid(asXML,(llBeginPos + Len("<" + asField + ">")),(llEndPos - (llBeginPos + Len("<" + asField + ">"))))

Return lsReturnCode
end function

public function string uf_request_header (string asname, string asattributes);
string	lsHeader, lsDatasource

// 10/12 - PCONKL - Add the datasource

//datasource is an optional override, may be present in the database or the .ini file. may not be present at all
lsDatasource = ProfileString(gs_inifile,"WEBSPHERE","datasource","")
If isnull(lsDatasource) or lsDatasource = '' Then
	lsDatasource = g.isWebsphereDatasource
End IF

If isnull(lsDatasource) Then lsDAtasource = ""

lsHeader = '<?xml version="1.0" encoding="UTF-8"?>'
lsHeader += '<SIMSMessage xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="Q:\xml_docs\Schema\SimsServicesV1.xsd">'
lsHeader += '<SIMSRequest name="' + asName + '" '

//Add servername and database name to header - server will verify that they are connected to the same database as client
//lsHeader += 'server="' + sqlca.servername + '" database="' + sqlca.database + '"'
//lsHeader += 'server="' + sqlca.servername + '" database="' + sqlca.database + '" UserID="'+ gs_userid + '"'
lsHeader += 'server="' + sqlca.servername + '" database="' + sqlca.database + '" UserID="'+ gs_userid + '" dataSource="'+ lsDatasource + '"'

lsHeader += ">"


lsheader += "<" + asName + " " + asattributes + ">"

Return lsheader
end function

public function string uf_post_url_old (string asarg, string asurl, integer aiport);
//This function uses the original PostURL function instead of the new Windows call that doesn't time out after 30 seconds

Blob	lbData, lbSendData
Long	llLength, llPos
Long	llTimeOut, llStatusCode
Integer	liRC, liPort, liFileNo
String	lsHeader, lsURL, lsReturn, lsXML, lsStatusText, lsREsponse
OleObject	loo_xmlhttp


//linit = Create Inet
This.GetContextService("Internet", linit)

llTimeOut = 1000000


lsXML = asARg

//we need to fix any "&" characters (i.e. K&N)
llPos = Pos(lsXml,"&",1)
Do While llPos > 0
	
	lsXml = Replace(lsXML,llPos,1,"&amp;")
	llPos +=3
	If llPos > Len(lsXml) Then
		llPOs = 0
	Else
		llPos = Pos(lsXml,"&",llPos)
	End If
	
Loop

lllength = Len(lsXML) 

lsHeader = "Content-Length: " & 
   + String(lllength) + "~n~n"


SetNull(ibReturnData )
ibDatabasbeenReturned = False

SetPointer(Hourglass!)

////get the URL and Port from the Database - check ini file first for override
//
//lsurl = ProfileString(gs_inifile,"WEBSPHERE","url","")
//liPort = long(ProfileString(gs_inifile,"WEBSPHERE","port",""))
//
////If not present, get from DB
//If lsurl = "" Then
//	
//	lsURL = g.isWebsphereUrl
//	liPort = g.ilwebspherePort
//	
//End If

lsURL = asURL
liPort = aiPort

If  lsURL = "" Then
	return "Unable to obtain Application Server connection URL information!"
End If

If liPort <=0 Then
	return "Unable to obtain Application Server connection port information!"
End If

lbSendData = blob(lsXML,EncodingUTF8!)
//liRC = linit.PostURL  (lsURL, blob(lsXML,EncodingANSI!), lsHeader, liPort, This)
liRC = linit.PostURL  (lsURL, lbSendData, lsHeader, liPort, This)

If liRC < 1 Then 
	
	lsReturn = "Websphere error: (" + String(lirc) + ") - "
	
	Choose Case liRC
			
		Case -1
			lsReturn += "General error"
		Case -2
			lsReturn += "Invalid URL"
		Case -4
			lsReturn += "Cannot connect to the Internet"
		Case -5
			lsReturn += "Unsupported secure (HTTPS) connection attempted"
		Case -6
			lsReturn += "Internet request failed~r(Probably unable to connect to server)"
		Case else
			lsReturn += "General error"
	End Choose
		
	lsReturn += "~r~rURL= " + lsURL + "~rPort= " + String(liPort)
	SetPointer(arrow!)
	Return lsReturn
	
End If


lbData = ibreturndata


SetPointer(arrow!)

Return String(lbData,EncodingUTF8!)


end function

public function string uf_post_url (string asarg, string asurl, integer aiport);
Blob	lbData
Long	llLength, llPos
Long	llTimeOut, llStatusCode
Integer	liRC, liPort, liFileNo
String	lsHeader, lsURL, lsReturn, lsXML, lsStatusText, lsREsponse
OleObject	loo_xmlhttp

//07/09 - PCONKL - PostURL now timing out with upgraded IE7. Switched to OLE Call.
// 08/09 - PCONKL -If this fails, use the original POSTURL call

//linit = Create Inet
//This.GetContextService("Internet", linit)


llTimeOut = 1000000


lsXML = asARg

//we need to fix any "&" characters (i.e. K&N)
llPos = Pos(lsXml,"&",1)
Do While llPos > 0
	
	lsXml = Replace(lsXML,llPos,1,"&amp;")
	llPos +=3
	If llPos > Len(lsXml) Then
		llPOs = 0
	Else
		llPos = Pos(lsXml,"&",llPos)
	End If
	
Loop

lllength = Len(lsXML)

lsHeader = "Content-Length: " & 
   + String(lllength) + "~n~n"


SetNull(ibReturnData )
ibDatabasbeenReturned = False

SetPointer(Hourglass!)

lsurl =asURL
liPort = aiPort

//get the URL and Port from the Database - check ini file first for override

If  lsURL = "" Then
	return "Unable to obtain Application Server connection URL information!"
End If

If liPort <=0 Then
	return "Unable to obtain Application Server connection port information!"
End If

//Return uf_post_url_old(asArg,lsURL,liPort) 


/*** If the new call fails, use the original call*/

//liRC = linit.PostURL  (lsURL, blob(lsXML), lsHeader, liPort, This)


loo_xmlhttp = Create OLEobject
loo_xmlhttp.ConnectTonewObject("MSXML2.ServerXMLHTTP.6.0")  // ET3 2012-07-30 :change per MS reference
//loo_xmlhttp.ConnectTonewObject("MSXML2.ServerXMLHTTP")  // ET3 2012-07-30 :change per MS reference
//loo_xmlhttp.ConnectTonewObject("MSXML2.ServerXMLHTTP.4.0")
loo_xmlhttp.SetTimeOuts(30000,30000,600000000,600000000)
loo_xmlhttp.Open ("POST",lsUrl,False)
//loo_xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
loo_xmlhttp.setRequestHeader("Content-Length", lsHeader)

Try
	loo_xmlhttp.Send(lsXML)
Catch (RuntimeError er)
	//Messagebox("Websphere Error",String(er))
	loo_xmlhttp.DisconnectObject()
	Return uf_post_url_old(asArg,lsURL,liPort) /*** If the new call fails, use the original call*/
Finally
	
End Try

llStatusCode = loo_xmlhttp.Status
lsStatusText = String(llStatusCode) + "-" + loo_xmlhttp.StatusText

If llStatusCode >= 300 Then
	loo_xmlhttp.DisconnectObject()
	Return lsStatusText
End If

lsResponse = loo_xmlhttp.ResponseText
loo_xmlhttp.DisconnectObject()


Return lsResponse



end function

on u_nvo_websphere_post.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_websphere_post.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

