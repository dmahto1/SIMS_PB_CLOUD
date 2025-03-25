HA$PBExportHeader$w_authorization.srw
$PBExportComments$Collect override authorization details - perform authentication of credentials
forward
global type w_authorization from w_response_ancestor
end type
type st_instructions from statictext within w_authorization
end type
type st_authorized_user from statictext within w_authorization
end type
type st_password from statictext within w_authorization
end type
type st_license from statictext within w_authorization
end type
type sle_authorized_user from singlelineedit within w_authorization
end type
type sle_password from singlelineedit within w_authorization
end type
type sle_license from singlelineedit within w_authorization
end type
type cb_authenticate from commandbutton within w_authorization
end type
end forward

global type w_authorization from w_response_ancestor
string title = "Order Authorization"
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
global w_authorization w_authorization

type variables
//string 	isEmbargoed_Override_User = ''
//string 	isEmbargoed_Override_License = ''
//datetime	idtEmbargoed_Override_Date = DateTime(today(),Now())

string 	isAuthorize_User = ''
string 	isAuthorize_License = ''
String     isAuthorize_Type = ''
datetime	idtAuthorize_Date = DateTime(today(),Now())

inet	linit
u_nvo_websphere_post	iuoWebsphere

string   isDefaultInstructions = 'Please log in with the credentials for a user ~r~n ' &
										  + 'authorized to override the Embargo restriction.~r~n ' &
										  + 'Please enter the required license number. '

String is_Type


end variables

on w_authorization.create
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

on w_authorization.destroy
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

event open;call super::open;//Developed by TimA 12/10/13

str_authorize strEC

this.sle_authorized_user.text = gs_userid
isAuthorize_user = gs_userid

idtAuthorize_Date = DateTime(today(),Now())

strEC = Message.PowerObjectParm		  

isAuthorize_Type = strEC.authorize_type

Choose Case isAuthorize_Type
		
	Case 'CI'
		This.sle_license.visible = False
		This.st_license.visible = False
		isDefaultInstructions = 'Please log in with the credentials for a user ~r~n ' &
										  + 'authorized.~r~n '
		this.st_instructions.text = isDefaultInstructions
											
	Case 'EMBARGO'
		IF strEC.authorize_license <> '' and (NOT ISNULL(strEC.authorize_license) ) THEN
			This.sle_license.visible = True
			This.st_license.visible = True
			this.st_instructions.text = isDefaultInstructions
			isAuthorize_license = strEC.authorize_license
			sle_license.text = strEC.authorize_license
		END IF	
		
	Case 'SS'			// ShortShip - PANDORA ISSUE 843 - Under Picking by Warehouse/Short Ship
		//IF strEC.authorize_license <> '' and (NOT ISNULL(strEC.authorize_license) ) THEN
			This.sle_license.visible = False
			This.st_license.visible = False
			isDefaultInstructions = 'Please log in with the credentials for a user ~r~n ' &
												+ 'authorized to approve a short ship order.~r~n ' 
			this.st_instructions.text = isDefaultInstructions
		//END IF
	
	//11-Sep-2015 :Madhu- As discussed in code review changed to provide F10 access.- START
	Case 'F10'
			This.sle_license.visible = False
			This.st_license.visible = False
			isDefaultInstructions = 'Please log in with the credentials for a Super User OR F10 Access User ~r~n ' &
												+ 'authorized to unlock the Order.~r~n ' 
			this.st_instructions.text = isDefaultInstructions
	//11-Sep-2015 :Madhu- As discussed in code review changed to provide F10 access.- END
End Choose


end event

event ue_postopen;call super::ue_postopen;
Long	llRowCOunt, llRowPos

Istrparms = Message.PowerobjectParm

cb_ok.Enabled = False


end event

type cb_cancel from w_response_ancestor`cb_cancel within w_authorization
integer x = 1371
integer y = 896
integer taborder = 60
end type

event cb_cancel::clicked;// override ancestor

str_authorize str_EC


	str_EC.authorize_license = ''
	str_EC.authorize_user = ''
	str_EC.nReturn	= -1

CloseWithReturn(parent, str_EC )
	

end event

type cb_ok from w_response_ancestor`cb_ok within w_authorization
integer x = 937
integer y = 896
integer taborder = 50
boolean enabled = false
string text = "Okay"
boolean default = false
end type

event cb_ok::clicked;// override ancestor
str_Authorize str_EC

// PANDORA ISSUE 843 - Under Picking by Warehouse/Short Ship - added SS
Choose case isAuthorize_Type 
	Case 'CI','SS'
		IF len(isAuthorize_User) > 0 THEN
			str_EC.Authorize_user = isAuthorize_user
			str_EC.Authorize_date = idtAuthorize_date
			str_EC.nReturn	= 1
		Else
			str_EC.Authorize_user = ''
			str_EC.nReturn	= -1
		End if
	Case 'EMBARGO'
		//TimA 12/12/13
		//When embargo authorized is moved from it's current window this could be used.
		IF len(isAuthorize_License) > 0 AND len(isAuthorize_User) > 0 THEN
			str_EC.Authorize_license = isAuthorize_license
			str_EC.Authorize_user = isAuthorize_user
			str_EC.Authorize_date = idtAuthorize_date
			str_EC.nReturn	= 1
		Else
			str_EC.Authorize_license = ''
			str_EC.Authorize_user = ''
			str_EC.nReturn	= -1			
		End If
	Case 'F10'
		IF len(isAuthorize_User) > 0 THEN
			str_EC.Authorize_user = isAuthorize_user
			str_EC.Authorize_date = idtAuthorize_date
			str_EC.authorize_type = isAuthorize_Type
			str_EC.nReturn	= 1
		Else
			str_EC.Authorize_user = ''
			str_EC.nReturn	= -1
		End if
	Case Else
		str_EC.Authorize_license = ''
		str_EC.Authorize_user = ''
		str_EC.nReturn	= -1
End Choose

CloseWithReturn(parent, str_EC )
	

end event

type st_instructions from statictext within w_authorization
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

type st_authorized_user from statictext within w_authorization
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

type st_password from statictext within w_authorization
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

type st_license from statictext within w_authorization
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

type sle_authorized_user from singlelineedit within w_authorization
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
	cb_ok.Enabled = False
	isAuthorize_user = this.text
	
	If len(sle_password.text) > 0  THEN 
		cb_authenticate.Enabled = TRUE
	Else
		cb_authenticate.Enabled = FALSE
	End If

ELSE
	isAuthorize_user = ''

END IF


end event

event getfocus;this.selecttext( 1, len(this.text))
end event

type sle_password from singlelineedit within w_authorization
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
	cb_ok.Enabled = False
	If len(sle_authorized_user.text) > 0  THEN 
		cb_authenticate.Enabled = TRUE
	Else
		cb_authenticate.Enabled = FALSE
	End If

END IF


end event

event getfocus;this.selecttext( 1, len(this.text))
end event

type sle_license from singlelineedit within w_authorization
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
	isAuthorize_license = this.text
ELSE
	isAuthorize_license = ''
	
END IF
	
end event

event getfocus;this.selecttext( 1, len(this.text))
end event

type cb_authenticate from commandbutton within w_authorization
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
String lsDatasource,lsDatabase
String lsCodeType

// check the credentials
IF sle_authorized_user.text > '' AND sle_password.text > '' THEN
	// perform the websphere check
	
	//Authenticate USER  on WEbsphere
	// 11/05 - PCONKL - Building Pick List from Websphere now
	iuoWebsphere = CREATE u_nvo_websphere_post
	linit = Create Inet

//	If lsDatasource > '' Then
//		g.isWebsphereDAtasource = lsDataSource
//	else
//		g.isWebsphereDAtasource = ''
//	End If
	
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
		
		//11-Sep-2015 :Madhu- As discussed in code review changed to provide F10 access.- Added 'F10'
		If isAuthorize_Type = 'SS' Then
			lsCodeType = 'SS_AUTHORIZE'
		Elseif isAuthorize_Type ='F10' Then
			lsCodeType='F10_AUTHORIZE'
		Else
			lsCodeType = 'CI_AUTHORIZE'
		End If
		
		//11-Sep-2015 :Madhu- As discussed in code review changed to provide F10 access. -START
		//Only Super User can release F10 access to operator
		long ll_count,ll_useraccess
		
		//Get Access Level of user whose credentails are provided to unlock the order
		select Access_Level into : ll_useraccess from UserTable with(nolock) where UserId=:sle_authorized_user.text using SQLCA;
		
		//check credentails provided user had already F10 access
		select count(*) into :ll_count from Lookup_Table with(nolock) 
		where Code_Type='F10_AUTHORIZE' and Code_Id=:sle_authorized_user.text
		and User_Updateable_Ind ='Y'
		using SQLCA;

		f_method_trace_special( gs_project, this.ClassName() + ' - clicked', 'Access Level# '+string(ll_useraccess) +' of F10 Access Authorized User# '+sle_authorized_user.text,gs_system_no, ' ',' ',gs_system_no) //07-Oct-2015  :Madhu added

		If ((ll_useraccess =0 or ll_useraccess =-1) and (isAuthorize_Type ='F10'))  THEN
			bAuthenticated = TRUE
		ElseIf ((ll_useraccess =1 or ll_useraccess =2) and (isAuthorize_Type ='F10') and (ll_count > 0)) THEN
			f_method_trace_special( gs_project, this.ClassName() + ' - clicked', 'Following User# '+sle_authorized_user.text + ' has already had F10 access',gs_system_no, ' ',' ',gs_system_no) //07-Oct-2015  :Madhu added
			bAuthenticated = TRUE
		ElseIf ((ll_useraccess =1 or ll_useraccess =2) and (isAuthorize_Type ='F10') and (ll_count=0)) THEN
			f_method_trace_special( gs_project, this.ClassName() + ' - clicked', 'Following User# '+sle_authorized_user.text + ' has not had F10 access',gs_system_no, ' ',' ',gs_system_no) //07-Oct-2015  :Madhu added
			bAuthenticated = FALSE
			MessageBox('Authorization Error','Please provide Super user credentials to Unlock the Order',StopSign!)	
			Return -1
		Else
			//11-Sep-2015 :Madhu- As discussed in code review changed to provide F10 access. -END
			SELECT count(*) INTO :nAuthorizedCnt
			FROM Lookup_Table
			WHERE Code_Type = :lsCodeType
			AND   Code_Id = :sle_authorized_user.text
			AND   Project_Id = :gs_project
			USING SQLCA;
			
			IF SQLCA.Sqlcode = 0 and nAuthorizedCnt > 0 THEN
				bAuthenticated = TRUE
			ELSE
				bAuthenticated = FALSE
				MessageBox('Authorization Error','The specified credentials are not authorized for this project',StopSign!)
			END IF
		End If //11-Sep-2015 :Madhu- As discussed in code review changed to provide F10 access.
		
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

