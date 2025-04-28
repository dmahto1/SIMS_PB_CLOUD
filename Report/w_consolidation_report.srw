HA$PBExportHeader$w_consolidation_report.srw
$PBExportComments$Consolidation Carrier Manifest Report
forward
global type w_consolidation_report from w_std_report
end type
type sle_consol_nbr from singlelineedit within w_consolidation_report
end type
type st_1 from statictext within w_consolidation_report
end type
end forward

global type w_consolidation_report from w_std_report
integer width = 3552
integer height = 2044
string title = "Consolidation Report"
sle_consol_nbr sle_consol_nbr
st_1 st_1
end type
global w_consolidation_report w_consolidation_report

type variables
String	isOrigSQL
end variables

on w_consolidation_report.create
int iCurrent
call super::create
this.sle_consol_nbr=create sle_consol_nbr
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_consol_nbr
this.Control[iCurrent+2]=this.st_1
end on

on w_consolidation_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_consol_nbr)
destroy(this.st_1)
end on

event ue_retrieve;
String	lsConsolNbr

lsConsolNbr = sle_consol_nbr.Text

dw_report.Retrieve(gs_project,lsConsolNbr)

If dw_report.RowCount() <=0 Then
	MessageBox('Consolidation','Consolidation Not Found!')
	sle_consol_nbr.SetFocus()
	sle_consol_nbr.SelectText(1,Len(sle_consol_nbr.Text))
	im_menu.m_file.m_print.Enabled = False
Else
	im_menu.m_file.m_print.Enabled = True
End If
end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-130)
end event

event ue_postopen;call super::ue_postopen;
DatawindowChild	Ldwc, ldwc2

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/

//populate ord type dropdown
dw_report.GetChild('consolidation_master_ord_type', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)

//If Consolidation window open, retrieve for Current Consolidation
If isValid(w_consolidation) Then
	If w_consolidation.idw_Main.RowCount() > 0 Then
		sle_consol_nbr.Text = w_consolidation.idw_Main.getITemString(1,'Consolidation_no')
		This.TriggerEvent('ue_retrieve')
	End If
End If

end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_Select.InsertRow(0)

end event

type dw_select from w_std_report`dw_select within w_consolidation_report
boolean visible = false
integer x = 23
integer width = 3086
integer height = 36
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_consolidation_report
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_consolidation_report
integer x = 5
integer y = 136
integer width = 3474
integer height = 1516
string dataobject = "d_consol_carrier_manifest_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type sle_consol_nbr from singlelineedit within w_consolidation_report
integer x = 530
integer y = 32
integer width = 544
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;
If This.Text > '' Then PArent.TriggerEvent('ue_Retrieve')
end event

type st_1 from statictext within w_consolidation_report
integer x = 41
integer y = 40
integer width = 480
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consolidation Nbr:"
boolean focusrectangle = false
end type

