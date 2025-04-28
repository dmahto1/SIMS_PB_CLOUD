HA$PBExportHeader$w_ro_return_address.srw
$PBExportComments$Return Address for Return Inbound Orders
forward
global type w_ro_return_address from w_response_ancestor
end type
type dw_address from u_dw_ancestor within w_ro_return_address
end type
end forward

global type w_ro_return_address from w_response_ancestor
integer width = 2450
integer height = 1484
string title = "Return Address"
dw_address dw_address
end type
global w_ro_return_address w_ro_return_address

type variables
String	isRONO
end variables

on w_ro_return_address.create
int iCurrent
call super::create
this.dw_address=create dw_address
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_address
end on

on w_ro_return_address.destroy
call super::destroy
destroy(this.dw_address)
end on

event ue_postopen;call super::ue_postopen;
istrparms = Message.PowerObjectParm

isRONO = istrparms.String_arg[1]

If dw_address.Retrieve(gs_project, isRoNo) > 0 Then
	
Else /*add a new row if doesn't already exist */
	
	dw_address.InsertRow(0)
	dw_address.SetItem(1,'ro_no',isRoNo)
	dw_address.SetItem(1,'project_id',gs_project)
	dw_address.SetITem(1,'address_type','RC')
	
End If

//If order is complete, don't allow any changes
If istrparms.String_arg[2] <> 'Y' Then
	dw_address.Object.DataWindow.ReadOnly="Yes"
End IF
end event

event closequery;call super::closequery;
Integer	liRC

//Save

If Istrparms.Cancelled Then Return 0

If dw_address.RowCount() > 0 Then
	
	SetPointer(Hourglass!)
	
	Execute Immediate "Begin Transaction" using SQLCA; 
	SQLCA.DBParm = "disablebind =0"
	liRC = dw_address.Update()
	SQLCA.DBParm = "disablebind =1"
	IF (liRC = 1) THEN
		Execute Immediate "COMMIT" using SQLCA;
	ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
      MessageBox('', SQLCA.SQLErrText)
		Return -1
   END IF
	
	SetPointer(arrow!)
	
End If
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_ro_return_address
integer x = 1202
integer y = 1236
end type

type cb_ok from w_response_ancestor`cb_ok within w_ro_return_address
integer x = 818
integer y = 1232
end type

type dw_address from u_dw_ancestor within w_ro_return_address
integer x = 23
integer y = 32
integer width = 2363
integer height = 1144
boolean bringtotop = true
string dataobject = "d_ro_return_address"
boolean border = false
borderstyle borderstyle = stylebox!
end type

