$PBExportHeader$w_delivery_pod.srw
$PBExportComments$Delivery Proof of Delivery
forward
global type w_delivery_pod from w_response_ancestor
end type
type dw_detail from u_dw_ancestor within w_delivery_pod
end type
type dw_header from u_dw_ancestor within w_delivery_pod
end type
type cb_1 from commandbutton within w_delivery_pod
end type
type cb_2 from commandbutton within w_delivery_pod
end type
end forward

global type w_delivery_pod from w_response_ancestor
integer width = 3209
integer height = 1696
string title = "Proof of Delivery"
dw_detail dw_detail
dw_header dw_header
cb_1 cb_1
cb_2 cb_2
end type
global w_delivery_pod w_delivery_pod

type variables

end variables

on w_delivery_pod.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.dw_header=create dw_header
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_header
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
end on

on w_delivery_pod.destroy
call super::destroy
destroy(this.dw_detail)
destroy(this.dw_header)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event ue_postopen;call super::ue_postopen;
Long	llRowCOunt, llRowPos

Istrparms = Message.PowerobjectParm

dw_header.Retrieve(istrparms.String_arg[1])
dw_header.SetItem(1,'Delivery_Date',today())

lLRowCount = dw_detail.Retrieve(istrparms.String_arg[1])

cb_ok.Enabled = False

If gs_project = 'BABYCARE' Then
	cb_2.visible = false
End IF
end event

event closequery;call super::closequery;
String	lsDONO
DateTime	ldtToday



//ldtToday = DateTime(today(),Now())
ldtToday = f_getLocalWorldTime( dw_header.getitemstring(1,'wh_code') ) 

If Not istrparms.Cancelled Then
	
	If MessageBox("POD", "Are you sure you want to CONFIRM this POD?",Question!,YesNo!,2) = 2 Then
		Return 1
	End If
	
	lsDONO = dw_header.GetITemString(1,'do_no')
	
	dw_header.SetItem(1,'ord_status','D')
	dw_header.SetItem(1,'last_update',ldtToday)
	dw_header.SetItem(1,'last_user',gs_userid)
	
	Execute Immediate "Begin Transaction" using SQLCA;
	dw_header.Update()
	dw_detail.Update()
	Execute Immediate "COMMIT" using SQLCA;
	
	//Write the POD transaction for the sweeper to pick up
	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
	Values(:gs_Project, 'PD', :lsDONO,'N', :ldtToday, '');
	Execute Immediate "COMMIT" using SQLCA;
	
End If

Message.PowerObjectParm = istrparms
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_delivery_pod
integer x = 453
integer y = 1368
integer taborder = 40
integer textsize = -8
end type

type cb_ok from w_response_ancestor`cb_ok within w_delivery_pod
integer x = 128
integer y = 1368
integer width = 247
integer textsize = -8
end type

type dw_detail from u_dw_ancestor within w_delivery_pod
integer x = 55
integer y = 172
integer width = 3090
integer height = 1104
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pod_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event itemchanged;call super::itemchanged;
cb_ok.Enabled = True
end event

type dw_header from u_dw_ancestor within w_delivery_pod
integer x = 50
integer y = 4
integer width = 1161
integer height = 132
boolean bringtotop = true
string dataobject = "d_pod_header"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_1 from commandbutton within w_delivery_pod
integer x = 1065
integer y = 1368
integer width = 357
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Accept All"
end type

event clicked;Int	i

For i = 1 to dw_detail.RowCount()
	dw_Detail.SetItem(i,'accepted_qty',dw_detail.GetITemNumber(i,'alloc_qty'))
Next


cb_ok.Enabled = True
end event

type cb_2 from commandbutton within w_delivery_pod
integer x = 1513
integer y = 1368
integer width = 306
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reject All"
end type

event clicked;Int	i

For i = 1 to dw_detail.RowCount()
	dw_Detail.SetItem(i,'accepted_qty',0)
Next


cb_ok.Enabled = True
end event

