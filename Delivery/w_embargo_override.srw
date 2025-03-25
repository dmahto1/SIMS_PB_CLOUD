HA$PBExportHeader$w_embargo_override.srw
$PBExportComments$Collect override authorization details - perform authentication of credentials
forward
global type w_embargo_override from w_response_ancestor
end type
type st_instructions from statictext within w_embargo_override
end type
type st_authorized_user from statictext within w_embargo_override
end type
type st_password from statictext within w_embargo_override
end type
type st_license from statictext within w_embargo_override
end type
type sle_authorized_user from singlelineedit within w_embargo_override
end type
type sle_password from singlelineedit within w_embargo_override
end type
type sle_license from singlelineedit within w_embargo_override
end type
type cb_authenticate from commandbutton within w_embargo_override
end type
end forward

global type w_embargo_override from w_response_ancestor
string title = "Embargo Override Authorization"
boolean controlmenu = false
boolean center = true
st_instructions st_instructions
st_authorized_user st_authorized_user
st_password st_password
st_license st_license
sle_authorized_user sle_authorized_user
sle_password sle_password
sle_license sle_license
cb_authenticate cb_authenticate
end type
global w_embargo_override w_embargo_override

type variables
string 	isEmbargoed_Override_User = ''
string 	isEmbargoed_Override_License = ''
datetime	idtEmbargoed_Override_Date = DateTime(today(),Now())

inet	linit
u_nvo_websphere_post	iuoWebsphere

string   isDefaultInstructions = 'Please log in with the credentials for a user ~r~n ' &
										  + 'authorized to override the Embargo restriction.~r~n ' &
										  + 'Please enter the required license number. '



end variables

on w_embargo_override.create
int iCurrent
call super::create
this.st_instructions=create st_instructions
this.st_authorized_user=create st_authorized_user
this.st_password=create st_password
this.st_license=create st_license
this.sle_authorized_user=create sle_authorized_user
this.sle_password=create sle_password
this.sle_license=create sle_license
this.cb_authenticate=create cb_authenticate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_instructions
this.Control[iCurrent+2]=this.st_authorized_user
this.Control[iCurrent+3]=this.st_password
this.Control[iCurrent+4]=this.st_license
this.Control[iCurrent+5]=this.sle_authorized_user
this.Control[iCurrent+6]=this.sle_password
this.Control[iCurrent+7]=this.sle_license
this.Control[iCurrent+8]=this.cb_authenticate
end on

on w_embargo_override.destroy
call super::destroy
destroy(this.st_instructions)
destroy(this.st_authorized_user)
destroy(this.st_password)
destroy(this.st_license)
destroy(this.sle_authorized_user)
destroy(this.sle_password)
destroy(this.sle_license)
destroy(this.cb_authenticate)
end on

event open;call super::open;// Window w_embargo_override 
// purpose: record details and validate for someone authorized to override an embargoed country restriction
// author:  Ermine Todd  2013-01-17

//string   isDefaultInstructions
//string 	isEmbargoed_Override_User
//string 	isEmbargoed_Override_License
//datetime	idtEmbargoed_Override_Date
str_embargoed_country strEC

this.st_instructions.text = isDefaultInstructions

this.sle_authorized_user.text = gs_userid
isEmbargoed_override_user = gs_userid

idtEmbargoed_Override_Date = DateTime(today(),Now())

strEC = Message.PowerObjectParm		  

IF strEC.sembargoed_override_license <> '' and (NOT ISNULL(strEC.sembargoed_override_license) ) THEN
	isEmbargoed_override_license = strEC.sembargoed_override_license
	sle_license.text = strEC.sembargoed_override_license
END IF

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_embargo_override
integer x = 1371
integer y = 896
integer taborder = 60
end type

event cb_cancel::clicked;// override ancestor

str_embargoed_country str_EC


	str_EC.sembargoed_override_license = ''
	str_EC.sembargoed_override_user = ''
	str_EC.nReturn	= -1

CloseWithReturn(parent, str_EC )
	

end event

type cb_ok from w_response_ancestor`cb_ok within w_embargo_override
integer x = 937
integer y = 896
integer taborder = 50
boolean enabled = false
string text = "Okay"
boolean default = false
end type

event cb_ok::clicked;// override ancestor
str_embargoed_country str_EC


IF len(isEmbargoed_Override_License) > 0 AND len(isEmbargoed_Override_User) > 0 THEN
	str_EC.sembargoed_override_license = isEmbargoed_override_license
	str_EC.sembargoed_override_user = isEmbargoed_override_user
	str_EC.dtembargoed_override_date = idtembargoed_override_date
	str_EC.nReturn	= 1
	
ELSE
	str_EC.sembargoed_override_license = ''
	str_EC.sembargoed_override_user = ''
	str_EC.nReturn	= -1

END IF

CloseWithReturn(parent, str_EC )
	

end event

type st_instructions from statictext within w_embargo_override
integer x = 41
integer y = 60
integer width = 1943
integer height = 268
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "instructions"
boolean focusrectangle = false
end type

type st_authorized_user from statictext within w_embargo_override
string tag = "Authorized User"
integer x = 105
integer y = 416
integer width = 562
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Authorized User:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_password from statictext within w_embargo_override
string tag = "password"
integer x = 210
integer y = 532
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Password:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_license from statictext within w_embargo_override
string tag = "License"
integer x = 210
integer y = 648
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "License:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_authorized_user from singlelineedit within w_embargo_override
integer x = 709
integer y = 384
integer width = 1047
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

event modified;
IF len(this.text) > 0 THEN
	isEmbargoed_override_user = this.text
	
	If len(sle_password.text) > 0  THEN 
		cb_authenticate.Enabled = TRUE
	Else
		cb_authenticate.Enabled = FALSE
	End If

ELSE
	isEmbargoed_override_user = ''

END IF


end event

event getfocus;this.selecttext( 1, len(this.text))
end event

type sle_password from singlelineedit within w_embargo_override
integer x = 709
integer y = 512
integer width = 1047
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
boolean password = true
borderstyle borderstyle = stylelowered!
end type

event modified;IF len(this.text) > 0 THEN

	If len(sle_authorized_user.text) > 0  THEN 
		cb_authenticate.Enabled = TRUE
	Else
		cb_authenticate.Enabled = FALSE
	End If

END IF


end event

event getfocus;this.selecttext( 1, len(this.text))
end event

type sle_license from singlelineedit within w_embargo_override
integer x = 709
integer y = 640
integer width = 1047
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

event modified;IF len(this.text) > 0 THEN
	isEmbargoed_override_license = this.text
ELSE
	isEmbargoed_override_license = ''
	
END IF
	
end event

event getfocus;this.selecttext( 1, len(this.text))
end event

type cb_authenticate from commandbutton within w_embargo_override
integer x = 306
integer y = 892
integer width = 466
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Authenticate"
boolean default = true
end type

event clicked;// clicked - perform the authentication against remote server
string lsAttributes
string lsXML
string lsXMLResponse
string lsReturnCode
string lsReturnDesc
string lsURL 
long   liport 

Boolean bAuthenticated = FALSE

// check the credentials
IF sle_authorized_user.text > '' AND sle_password.text > '' THEN
	// perform the websphere check
	
	//Authenticate USER  on WEbsphere
	// 11/05 - PCONKL - Building Pick List from Websphere now
	iuoWebsphere = CREATE u_nvo_websphere_post
	linit = Create Inet

	lsAttributes = ' NTUserID = "' + sle_authorized_user.text + '" NTPassword = "' + sle_password.text + '"'
	lsXML = iuoWebsphere.uf_request_header("AuthenticateUserRequest", lsAttributes)
	lsXML = iuoWebsphere.uf_request_footer(lsXML)

	lsURL = g.iswebsphereurl
	liport = g.ilwebsphereport

	lsXMLResponse = iuoWebsphere.uf_post_url(lsXML, lsURL, liPort)

	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		Messagebox("Websphere Fatal Exception Error","Unable to Authenticate User: ~r~r" + lsXMLResponse,StopSign!)
		bAuthenticated = FALSE 
	End If

	lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

	If lsReturnCode<> "0"  Then
		MessageBox("Authentication Error",lsReturnDesc,StopSign!)
		bAuthenticated = FALSE
	Else
		// now check for authorized user in the lookup table
		LONG nAuthorizedCnt
		
		SELECT count(*) INTO :nAuthorizedCnt
		FROM Lookup_Table
		WHERE Code_Type = 'EMBARGOED_OVERRIDE'
		AND   Code_Id = :sle_authorized_user.text
		AND   Project_Id = :gs_project
		USING SQLCA;
		
		IF SQLCA.Sqlcode = 0 and nAuthorizedCnt > 0 THEN
			bAuthenticated = TRUE
		ELSE
			bAuthenticated = FALSE
			MessageBox('Authorization Error','The specified credentials are not authorized for this project',StopSign!)
		END IF
				
	End If

ELSE
	MessageBox('INFO', 'Please make sure all fields are entered')
	
END IF


cb_ok.Enabled = bAuthenticated

//IF bAuthenticated THEN
//	cb_ok.Enabled = TRUE
//	cb_ok.Visible = TRUE
//
//ELSE
//	cb_ok.Enabled = FALSE
//	cb_ok.Visible = FALSE
//	
//END IF




end event

