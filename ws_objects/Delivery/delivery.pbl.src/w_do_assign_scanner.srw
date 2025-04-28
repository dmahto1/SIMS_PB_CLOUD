$PBExportHeader$w_do_assign_scanner.srw
$PBExportComments$- Assign Scanner ID to Orders
forward
global type w_do_assign_scanner from w_main_ancestor
end type
type st_1 from statictext within w_do_assign_scanner
end type
type dw_assign_scanner from datawindow within w_do_assign_scanner
end type
type ddlb_scanner_id from dropdownlistbox within w_do_assign_scanner
end type
type cb_selectall from commandbutton within w_do_assign_scanner
end type
type cb_clear from commandbutton within w_do_assign_scanner
end type
type cb_assign from commandbutton within w_do_assign_scanner
end type
end forward

global type w_do_assign_scanner from w_main_ancestor
integer width = 2903
integer height = 1720
string title = "Assign Scanner ID to Delivery Orders"
event ue_selectall ( )
event ue_clear ( )
event ue_apply ( )
event type integer ue_save ( )
event ue_update ( )
event ue_assign ( )
st_1 st_1
dw_assign_scanner dw_assign_scanner
ddlb_scanner_id ddlb_scanner_id
cb_selectall cb_selectall
cb_clear cb_clear
cb_assign cb_assign
end type
global w_do_assign_scanner w_do_assign_scanner

type variables
datastore ids_scanner_id
Boolean	ibChanged




end variables

event ue_selectall;
long	llRowCOunt,	&
		llRowPos
		
dw_assign_scanner.SetRedraw(False)

llRowCOunt = dw_assign_scanner.RowCount()

For llRowPos = 1 to llRowCount
	dw_assign_scanner.SetITem(llRowPos,'c_select_ind','Y')
Next

dw_assign_scanner.SetRedraw(True)
end event

event ue_clear;
long	llRowCOunt,	&
		llRowPos
		
dw_assign_scanner.SetRedraw(False)

llRowCOunt = dw_assign_scanner.RowCount()

For llRowPos = 1 to llRowCount
	dw_assign_scanner.SetITem(llRowPos,'c_select_ind','N')
Next

dw_assign_scanner.SetRedraw(True)

end event

event type integer ue_save();Integer	liRC

// pvh 11/23/05 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 
dw_assign_scanner.SetItem(1,'last_update', ldtToday ) 
//dw_assign_scanner.SetItem(1,'last_update',Today()) 
dw_assign_scanner.SetItem(1,'last_user',gs_userid) 

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

liRC = dw_assign_scanner.Update()
If liRC < 0 Then
	MessageBox('Assign Scanner','Unable to Save changes to records.')
	Execute Immediate "ROLLBACK" using SQLCA;
	Return -1
End If

Execute Immediate "COMMIT" using SQLCA;

Return 0
end event

event ue_assign;Long	llRowPos,	&
		llRowCount


//Update Scanner ID in datawindow only!
ibChanged = true
llRowCount = dw_assign_scanner.RowCOunt()
For llRowPos = 1 to llRowCount
	If dw_assign_scanner.GetITemString(llRowPos,'c_select_ind') = 'Y'  Then
  		dw_assign_scanner.SetITem(llRowPos,"scanner_id", ddlb_scanner_id.text)
	End If
Next
end event

on w_do_assign_scanner.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_assign_scanner=create dw_assign_scanner
this.ddlb_scanner_id=create ddlb_scanner_id
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.cb_assign=create cb_assign
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_assign_scanner
this.Control[iCurrent+3]=this.ddlb_scanner_id
this.Control[iCurrent+4]=this.cb_selectall
this.Control[iCurrent+5]=this.cb_clear
this.Control[iCurrent+6]=this.cb_assign
end on

on w_do_assign_scanner.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_assign_scanner)
destroy(this.ddlb_scanner_id)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.cb_assign)
end on

event ue_postopen;call super::ue_postopen;
ibChanged = False

//Retrieve Orders
This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;		
Long		llRowCount, llRowPos

IF IsValid(ids_scanner_id) = FALSE THEN //GAP 1/03 -  retrieve scanner id's once
	ids_scanner_id = Create datastore
	ids_scanner_id.Dataobject = 'd_scanner'
	ids_scanner_id.SetTransObject(sqlca)
end if			

llRowCount = ids_scanner_id.Retrieve()

If llRowCount <=0 Then // GAP 1-03 check to see of scanners exist.
	Messagebox('Assign Scanner','There are no Scanner IDs available.')
else  // GAP 1-03 retireve available orders to be assigned 
	
	For llRowPos = 1 to llRowCount// GAP 1-03  loop and set the values to "ddlb_scanner_id"
		this.ddlb_scanner_id.additem(ids_scanner_id.getitemstring(llRowPos,'scanner_id')) 
	Next
	this.ddlb_scanner_id.text = 'NONE'
	dw_assign_scanner.SetTrans(SQLCA)
	llRowCount = dw_assign_scanner.Retrieve(gs_project)
	If llRowCount <=0 Then
		Messagebox('Assign Scanner','There were no orders found.')
	end if
End If







end event

event closequery;call super::closequery;Integer	liRC


If ibchanged Then
	Choose Case Messagebox('Assign New Scanner ID to ALL Orders selected',"Save changes?",Question!,yesnocancel!,1)
		Case 1
			liRC = This.Trigger event ue_save()
			Return Lirc
		Case 2
			ibchanged = False
			Return 0
		Case 3
			Return 0
	End Choose
Else
	Return 0
End If
end event

event resize;call super::resize;dw_assign_scanner.Resize(workspacewidth() - 80,workspaceHeight()-260)

//Keep the buttons at the bottom
cb_selectall.Move(cb_selectall.x,(workspaceHeight()-90))
cb_clear.Move(cb_clear.x,(workspaceHeight()-90))
cb_ok.Move(cb_ok.x,(workspaceHeight()-90))
cb_cancel.Move(cb_cancel.x,(workspaceHeight()-90))
cb_assign.Move(cb_assign.x,(workspaceHeight()-90))
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_do_assign_scanner
integer x = 2537
integer y = 1432
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
end type

type cb_ok from w_main_ancestor`cb_ok within w_do_assign_scanner
integer x = 2158
integer y = 1432
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
boolean default = false
end type

type st_1 from statictext within w_do_assign_scanner
integer x = 59
integer y = 48
integer width = 2181
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "The Scanner selected here will be assigned to all checked orders below:"
boolean focusrectangle = false
end type

type dw_assign_scanner from datawindow within w_do_assign_scanner
integer x = 41
integer y = 152
integer width = 2752
integer height = 256
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_do_assign_scanner"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_scanner_id from dropdownlistbox within w_do_assign_scanner
integer x = 2194
integer y = 32
integer width = 558
integer height = 400
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type cb_selectall from commandbutton within w_do_assign_scanner
integer x = 41
integer y = 1432
integer width = 297
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;parent.TriggerEvent('ue_selectall')
end event

type cb_clear from commandbutton within w_do_assign_scanner
integer x = 402
integer y = 1432
integer width = 325
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;Parent.TriggerEvent('ue_clear')
end event

type cb_assign from commandbutton within w_do_assign_scanner
integer x = 1774
integer y = 1432
integer width = 270
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Assign"
boolean default = true
end type

event clicked;Parent.TriggerEvent('ue_assign')
end event

