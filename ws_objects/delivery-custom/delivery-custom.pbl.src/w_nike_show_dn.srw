$PBExportHeader$w_nike_show_dn.srw
$PBExportComments$Show Nike DN's on an order
forward
global type w_nike_show_dn from w_response_ancestor
end type
type dw_dn from u_dw_ancestor within w_nike_show_dn
end type
end forward

global type w_nike_show_dn from w_response_ancestor
integer width = 1074
integer height = 1408
string title = "Delivery Note Nbrs"
dw_dn dw_dn
end type
global w_nike_show_dn w_nike_show_dn

on w_nike_show_dn.create
int iCurrent
call super::create
this.dw_dn=create dw_dn
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_dn
end on

on w_nike_show_dn.destroy
call super::destroy
destroy(this.dw_dn)
end on

event ue_postopen;call super::ue_postopen;
Long	llRowCOunt, llRowPos, llNewRow
String	lsDN

//display a list of unique Nike Delivery Notes which are stored in Delivery_Detail.UF1

If Not isvalid(w_do) then Close(This)

dw_dn.SetRedraw(false)

llRowCount = w_do.idw_detail.RowCount()

If llRowCount <= 0 Then Return

For llRowPos = 1 to llRowCount
	
	lsDN = w_do.idw_Detail.GetITemString(lLRowPos,'User_Field1')
	If Not isnull(lsDN) and lsDN > '' Then
		
		If dw_dn.Find("Delivery_Note = '" + lsDN + "'",1,w_do.idw_Detail.RowCount()) = 0 Then
			llNewRow = dw_dn.InsertRow(0)
			dw_dn.SetITem(llNewRow,'DElivery_Note',lsDN)
		End IF
		
	End IF
	
Next

dw_dn.SetReDraw(True)
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_nike_show_dn
boolean visible = false
integer x = 814
integer y = 1144
end type

type cb_ok from w_response_ancestor`cb_ok within w_nike_show_dn
integer x = 379
integer y = 1168
end type

type dw_dn from u_dw_ancestor within w_nike_show_dn
integer x = 41
integer y = 40
integer width = 965
integer height = 1104
boolean bringtotop = true
string dataobject = "d_nike_show_dn"
end type

