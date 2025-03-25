$PBExportHeader$w_pandora_intransit_rpt.srw
$PBExportComments$Pandora Intransit report
forward
global type w_pandora_intransit_rpt from w_std_report
end type
end forward

global type w_pandora_intransit_rpt from w_std_report
integer width = 4128
integer height = 2220
string title = "Pandora Intransit Report"
end type
global w_pandora_intransit_rpt w_pandora_intransit_rpt

type variables
inet	linit
u_nvo_websphere_post	iuoWebsphere

end variables

on w_pandora_intransit_rpt.create
call super::create
end on

on w_pandora_intransit_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-30)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;
////Retrieve report on Websphere

String	lsxml, lsXMLResponse, lsReturnCode, lsReturnDesc

linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("PandoraInTransitReportRequest", "ProjectID='" + gs_Project + "'")
lsXML = iuoWebsphere.uf_request_footer(lsXML)

////Messagebox("",lsXML)

w_main.setMicroHelp("Retrieving Intransit report on Application server...")

dw_report.reset()

lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

//Messagebox("XML response",lsXMLResponse)


//Check for Valid Return...
//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error","Unable to retrieve Intransit Report records: ~r~r" + lsXMLResponse,StopSign!)
	Return 
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error","Unable to retrieve Intransit Report records: ~r~r" + lsReturnDesc,StopSign!)
		Return 
	
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		End If
			
End Choose

//import XML into DW
If pos(Upper(lsXMLResponse),"INTRANSITRECORD") > 0 Then
	dw_report.modify("datawindow.import.xml.usetemplate='pandoraintransitreport'")
	dw_report.ImportString(xml!,lsXMLResponse)
End If

dw_report.sort()
	
IF dw_report.RowCount() <= 0  THEN
	
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
	
End If

im_menu.m_file.m_print.Enabled = True




end event

event ue_postopen;//ancestor being overridden

iuoWebsphere = CREATE u_nvo_websphere_post

idw_current = dw_Report
end event

type dw_select from w_std_report`dw_select within w_pandora_intransit_rpt
boolean visible = false
integer x = 0
integer y = 32
integer width = 4265
integer height = 36
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_pandora_intransit_rpt
integer x = 4279
integer y = 8
integer width = 261
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_pandora_intransit_rpt
integer x = 37
integer y = 0
integer width = 3977
integer height = 1804
integer taborder = 30
string dataobject = "d_pandora_intransit_rpt"
boolean hscrollbar = true
end type

