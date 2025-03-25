HA$PBExportHeader$w_select_report.srw
$PBExportComments$Select Reports from Main Menu
forward
global type w_select_report from window
end type
type st_rep from statictext within w_select_report
end type
type st_2 from statictext within w_select_report
end type
type cb_cancel from commandbutton within w_select_report
end type
type st_1 from statictext within w_select_report
end type
type sle_report from singlelineedit within w_select_report
end type
type dw_reports from datawindow within w_select_report
end type
type st_3 from statictext within w_select_report
end type
end forward

global type w_select_report from window
integer x = 1056
integer y = 484
integer width = 1413
integer height = 2104
windowtype windowtype = popup!
long backcolor = 79741120
st_rep st_rep
st_2 st_2
cb_cancel cb_cancel
st_1 st_1
sle_report sle_report
dw_reports dw_reports
st_3 st_3
end type
global w_select_report w_select_report

type variables
str_parms	istrparms
end variables

on w_select_report.create
this.st_rep=create st_rep
this.st_2=create st_2
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.sle_report=create sle_report
this.dw_reports=create dw_reports
this.st_3=create st_3
this.Control[]={this.st_rep,&
this.st_2,&
this.cb_cancel,&
this.st_1,&
this.sle_report,&
this.dw_reports,&
this.st_3}
end on

on w_select_report.destroy
destroy(this.st_rep)
destroy(this.st_2)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.sle_report)
destroy(this.dw_reports)
destroy(this.st_3)
end on

event open;Integer	liRC
Long	llRowCount, llRowPos


//Position the window at the cursor
//TimA 07/15/15 because we are now opening this window with parms we have to move it up a little
This.move(w_main.PointerX() - 150, w_main.PointerY() + 60 )
//This.move(w_main.PointerX() - 150, w_main.PointerY() + 225 )

//Share report datawindow with the global datastore which is populated at login

liRC = g.ids_reports.Sharedata(dw_reports)

// 04/13 - PCONKL - If not currently connected to Replication for whatever reason, don't show in Green
If Not  gb_replication_sqlca_connected Then
	
	llRowCount = dw_reports.RowCount()
	For llRowPos = 1 to llRowCount
		dw_reports.SetItem(llRowPos,'Replication_Server_Enabled','N')
	Next

End If

If dw_reports.RowCount() > 0 Then
	sle_report.SetFocus()
Else
	sle_report.Enabled = False
End If

If not gb_replication_sqlca_connected Then
	st_rep.visible = False
End If
end event

event deactivate;
Close(This)
end event

event activate;gs_ActiveWindow ='REPORT' //05-May-2014:Madhu- Added to open User Manual upon press F1 key
end event

type st_rep from statictext within w_select_report
integer x = 46
integer y = 1940
integer width = 1326
integer height = 140
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 32768
long backcolor = 67108864
string text = "Reports listed in Green are currently running against the Replicated server"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_select_report
integer x = 160
integer y = 1792
integer width = 1152
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "Double click a report or enter a report "
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_select_report
integer x = 887
integer y = 1696
integer width = 247
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;
istrparms.cancelled = True
Close(parent)
end event

type st_1 from statictext within w_select_report
integer x = 151
integer y = 1696
integer width = 288
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Report #:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_report from singlelineedit within w_select_report
integer x = 443
integer y = 1696
integer width = 178
integer height = 72
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;
string sbegin = 'report_seq = '
string sSearchFor
long lFoundRow
long lSequence
string ls_Permissions,lsReport

// pvh - 08/16/05
// modified to use seq instead of row()
//
If not isnumber( This.Text ) Then
	beep(1)
	This.SelectText(1,len(This.Text))
Else
	lSequence = long(This.Text)
	sSearchFor = sBegin + this.text
	lFoundRow = dw_reports.find( sSearchfor, 1, dw_reports.rowcount() )
	if lFoundRow > 0 then
	    //TimA 07/08/15 Add Required Permissions to the String Parm
	    //message.StringParm   = dw_reports.object.Report_id[ lFoundRow ] + ',' +  dw_reports.object.project_reports_required_permissions[ lFoundRow ]
	   message.StringParm   = dw_reports.object.Report_id[ lFoundRow ]
		ls_Permissions =  dw_reports.object.project_reports_required_permissions[ lFoundRow ]
		lsReport = dw_reports.object.Report_id[ lFoundRow ]
		//If Permissions required the check for Access Rights.
		If ls_Permissions = 'Y'  Then
			//Pandora wants to check everyone that is greater than super user
			If gs_Project = 'PANDORA' Then
				If   (gs_role <> '0' and  gs_role <> '-1') Then
					if g.getFunctionRights( lsReport, 'E' ) = false then 
						MessageBox("Security Check", "You don't have permissions to run this report!",StopSign!)
						//This.SelectText(1,len(This.Text))
						Return 0
					End if
				End if
			Else
				if g.getFunctionRights( lsReport, 'E' ) = false then 
					MessageBox("Security Check", "You don't have permissions to run this report!",StopSign!)
					return 0		
				End if
			End if
		End if

		w_main.TriggerEvent("ue_load_report")
	else
		beep( 1)
		This.SelectText(1,len(This.Text))
	end if
End If
end event

type dw_reports from datawindow within w_select_report
integer x = 14
integer y = 8
integer width = 1371
integer height = 1660
integer taborder = 10
string dataobject = "d_project_reports"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;
If Row > 0 Then
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
End If
end event

event doubleclicked;string ls_Permissions,lsReport

// Open selected report - report_id passed back to w_main and opened from there

If Row > 0 Then
	//TimA 07/08/15 Add Required Permissions to the String Parm
		//message.StringParm = This.GetITemString(row,'report_id') + ',' + This.GetITemString(row,'project_reports_required_permissions')
		ls_Permissions =  dw_reports.object.project_reports_required_permissions[ Row ]
		lsReport = dw_reports.object.Report_id[ Row ]
		message.StringParm = This.GetITemString(row,'report_id') 
		
		//If Permissions required the check for Access Rights.
		If ls_Permissions = 'Y'  Then
			//Pandora wants to check everyone that is greater than super user
			If gs_Project = 'PANDORA' Then
				If   (gs_role <> '0' and  gs_role <> '-1') Then
					if g.getFunctionRights( lsReport, 'E' ) = false then 
						MessageBox("Security Check", "You don't have permissions to run this report!",StopSign!)
						Return 0
					End if
				End if
			Else
				if g.getFunctionRights( lsReport, 'E' ) = false then 
					MessageBox("Security Check", "You don't have permissions to run this report!",StopSign!)
					return 0		
				End if
			End if
		End if
	
	w_main.TriggerEvent("ue_load_report")

End If
end event

type st_3 from statictext within w_select_report
integer x = 160
integer y = 1840
integer width = 558
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "number and hit enter."
boolean focusrectangle = false
end type

