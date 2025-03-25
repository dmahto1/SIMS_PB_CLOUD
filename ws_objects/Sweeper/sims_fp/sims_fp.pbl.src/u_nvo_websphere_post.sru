$PBExportHeader$u_nvo_websphere_post.sru
$PBExportComments$Post a URL Transaction to Websphere (BCR 02-AUG-2011: Copied over from SIMS Common.pbl)
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
public function string uf_post_url_old (string asarg)
end prototypes

public function integer internetdata (blob data);
ibReturnData = data
ibDatabasbeenReturned = True

Return 0

end function

public function string uf_request_header (string asname);String	lsHeader, lsDatasource

//Jxlim 03/08/2013 - Add the datasource per Pete

//datasource is an optional override, may be present in the database or the .ini file. may not be present at all
lsDatasource = ProfileString(gsinifile,"WEBSPHERE","datasource","")
//If not present in gsinifile, get from DB
If isnull(lsDatasource) or lsDatasource = '' Then
//	lsDatasource = g.isWebsphereDatasource  //Unlike SIMS client; g.isWebsphereDatasource is declared at appmanager, sweeper does not use appmanager ...
	Select connection_datasource_name
	Into	:lsDatasource
	From  Websphere_settings
	Using SQLCA;	
End IF

If Isnull(lsDatasource) Then lsDatasource = ""

//Jxlim 04/11/2013 No necessary for message (Sims33PRD,Sims33Pan and Sims33Test are having blank datastore connection on the table, except sims33Dev, reason becasue
//sims33dev is pointing to the same URL as sims33Test))
//If  lsDatasource = "" Then
//	Return "Unable to obtain Application Server connection Datasource information!"
//End If

lsHeader = '<?xml version="1.0" encoding="UTF-8"?>'
lsHeader += '<SIMSMessage xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="Q:\xml_docs\Schema\SimsServicesV1.xsd">'
lsHeader += '<SIMSRequest name="' + asName + '" '

//Add servername and database name to header - server will verify that they are connected to the same database as client
//lsHeader += 'server="' + sqlca.servername + '" database="' + sqlca.database + '" UserID="'+ sqlca.userid + '"'
//Jxlim 03/08/2013 Added datasource per Pete
lsHeader += 'server="' + sqlca.servername + '" database="' + sqlca.database + '" UserID="'+ sqlca.userid + '" dataSource="'+ lsDatasource + '"'

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


// ET3 2013-01-07 - use modified new call to websphere
//**** 05/12 - PCONKL - new call not working on new server disabling for now****
//Return uf_post_url_old(asArg) /*** If the new call fails, use the original call*/

// *************************************************************

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

//get the URL and Port from the Database - check ini file first for override

lsurl = ProfileString(gsIniFile,"WEBSPHERE","url","")
liPort = long(ProfileString(gsIniFile,"WEBSPHERE","port",""))

//If not present, get from DB   
//BCR 05-AUG-2011: This code block modified to reflect that Sweeper, unlike SIMS, does not use appmanager ...
If lsurl = "" Then

	Select connection_url, connection_port
	Into	:lsURL, :liPort
	From websphere_settings;
	
End If

If  lsURL = "" Then
	return "Unable to obtain Application Server connection URL information!"
End If

If liPort <=0 Then
	return "Unable to obtain Application Server connection port information!"
End If

loo_xmlhttp = Create OLEobject
loo_xmlhttp.ConnectTonewObject("MSXML2.ServerXMLHTTP.6.0")  // ET3 2012-07-30 :change per MS reference
//loo_xmlhttp.ConnectTonewObject("MSXML2.ServerXMLHTTP.4.0")
loo_xmlhttp.SetTimeOuts(30000,30000,600000000,600000000)
loo_xmlhttp.Open ("POST",lsUrl,False)
loo_xmlhttp.setRequestHeader("Content-Length", lsHeader)

Try
	loo_xmlhttp.Send(lsXML)
Catch (RuntimeError er)
	loo_xmlhttp.DisconnectObject()
	Return uf_post_url_old(asArg) /*** If the new call fails, use the original call*/
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

public function string uf_get_xml_single_element (string asxml, string asfield);

String	lsReturnCode
long		llBeginPos, llEndPos

llBeginPos = Pos(Upper(asXML),"<" + Upper(asField) + ">")
llEndPos = Pos(Upper(asXML),"</" + Upper(asField) + ">")

If llBeginPOs = 0 or llEndPos = 0 Then Return ""

lsReturnCode = Mid(asXML,(llBeginPos + Len("<" + asField + ">")),(llEndPos - (llBeginPos + Len("<" + asField + ">"))))

Return lsReturnCode
end function

public function string uf_request_header (string asname, string asattributes);String	lsHeader, lsDatasource

//Jxlim 03/08/2013 - Add the datasource per Pete C

//datasource is an optional override, may be present in the database or the .ini file. may not be present at all
lsDatasource = ProfileString(gsinifile,"WEBSPHERE","datasource","")
//If not present in gsinifile, get from DB
If isnull(lsDatasource) or lsDatasource = '' Then
//	lsDatasource = g.isWebsphereDatasource  //Unlike SIMS client; g.isWebsphereDatasource is declared at appmanager, sweeper does not use appmanager ...
	Select connection_datasource_name
	Into	:lsDatasource
	From  Websphere_settings
	Using SQLCA;	
End IF

If Isnull(lsDatasource) Then lsDatasource = ""

//Jxlim 04/11/2013 No necessary for message (Sims33PRD,Sims33Pan and Sims33Test are having blank datastore connection on the table, except sims33Dev, reason becasue
//sims33dev is pointing to the same URL as sims33Test))
//If  lsDatasource = "" Then
//	Return "Unable to obtain Application Server connection Datasource information!"
//End If

lsHeader = '<?xml version="1.0" encoding="UTF-8"?>'
lsHeader += '<SIMSMessage xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="Q:\xml_docs\Schema\SimsServicesV1.xsd">'
lsHeader += '<SIMSRequest name="' + asName + '" '

//Add servername and database name to header - server will verify that they are connected to the same database as client
//lsHeader += 'server="' + sqlca.servername + '" database="' + sqlca.database + '"'
//Jxlim 03/08/2013 Added datasource per Pete
//lsHeader += 'server="' + sqlca.servername + '" database="' + sqlca.database + '" UserID="'+ sqlca.userid + '"'
lsHeader += 'server="' + sqlca.servername + '" database="' + sqlca.database + '" UserID="'+ sqlca.userid + '" dataSource="'+ lsDatasource + '"'

lsHeader += ">"

lsheader += "<" + asName + " " + asattributes + ">"

Return lsheader
end function

public function string uf_post_url_old (string asarg);
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

lsurl = ProfileString(gsIniFile,"WEBSPHERE","url","")
liPort = long(ProfileString(gsIniFile,"WEBSPHERE","port",""))

//If not present, get from DB   
//BCR 05-AUG-2011: This code block modified to reflect that Sweeper, unlike SIMS, does not use appmanager ...
If lsurl = "" Then

	Select connection_url, connection_port
	Into	:lsURL, :liPort
	From websphere_settings;
	
End If

If  lsURL = "" Then
	return "Unable to obtain Application Server connection URL information!"
End If

If liPort <=0 Then
	return "Unable to obtain Application Server connection port information!"
End If

lbSendData = blob(lsXML,EncodingUTF8!)

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

on u_nvo_websphere_post.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_websphere_post.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

