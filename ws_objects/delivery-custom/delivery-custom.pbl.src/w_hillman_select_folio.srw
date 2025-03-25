$PBExportHeader$w_hillman_select_folio.srw
$PBExportComments$Select Folio for Hillman Packing List
forward
global type w_hillman_select_folio from w_response_ancestor
end type
type dw_folio from datawindow within w_hillman_select_folio
end type
end forward

global type w_hillman_select_folio from w_response_ancestor
integer width = 1019
integer height = 856
string title = "Select Folio"
dw_folio dw_folio
end type
global w_hillman_select_folio w_hillman_select_folio

type variables
str_parms	istrparms
end variables

on w_hillman_select_folio.create
int iCurrent
call super::create
this.dw_folio=create dw_folio
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_folio
end on

on w_hillman_select_folio.destroy
call super::destroy
destroy(this.dw_folio)
end on

event open;call super::open;istrparms = Message.PowerObjectParm
end event

event ue_postopen;call super::ue_postopen;
istrparms.datastore_arg[1].Sharedata(dw_folio)
end event

event closequery;call super::closequery;Int i

//return the selected folio
For i = 1 to dw_folio.RowCount()
	If dw_folio.GetItemString(i,'c_select') = 'Y' Then
		Istrparms.String_arg[1] = dw_folio.GetItemString(i,'user_Field10')
	End If
Next

Message.powerObjectParm = istrparms
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_hillman_select_folio
integer x = 535
integer y = 640
integer height = 96
integer textsize = -8
end type

type cb_ok from w_response_ancestor`cb_ok within w_hillman_select_folio
integer x = 187
integer y = 640
integer height = 96
integer textsize = -8
end type

type dw_folio from datawindow within w_hillman_select_folio
integer x = 27
integer y = 32
integer width = 951
integer height = 560
integer taborder = 10
boolean bringtotop = true
string title = "Select Folio"
string dataobject = "d_hillman_select_folio"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Int	i
//If checking a row, uncheck others
if dwo.name = 'c_select' and data = 'Y' Then
	For i= 1 to This.RowCount()
		If i  = row then continue
		this.SetITem(i,'c_select','N')
	next
	
End If
end event

