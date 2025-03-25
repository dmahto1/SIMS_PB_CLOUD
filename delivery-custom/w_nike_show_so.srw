HA$PBExportHeader$w_nike_show_so.srw
$PBExportComments$Show Nike DN's on an order
forward
global type w_nike_show_so from w_response_ancestor
end type
type dw_so from u_dw_ancestor within w_nike_show_so
end type
end forward

global type w_nike_show_so from w_response_ancestor
integer width = 1074
integer height = 1408
string title = "Sales Order Nbrs"
dw_so dw_so
end type
global w_nike_show_so w_nike_show_so

on w_nike_show_so.create
int iCurrent
call super::create
this.dw_so=create dw_so
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_so
end on

on w_nike_show_so.destroy
call super::destroy
destroy(this.dw_so)
end on

event ue_postopen;call super::ue_postopen;
Long	llRowCOunt, llRowPos, llNewRow
String	lsSO

//display a list of unique Nike Delivery Notes which are stored in Delivery_Detail.UF1

If Not isvalid(w_do) then Close(This)

dw_so.SetRedraw(false)

llRowCount = w_do.idw_detail.RowCount()

If llRowCount <= 0 Then Return

For llRowPos = 1 to llRowCount
	
	lsSO = w_do.idw_Detail.GetITemString(lLRowPos,'User_Field4')
	If Not isnull(lsSO) and lsSO > '' Then
		
		If dw_so.Find("sales_order = '" + lsSO + "'",1,w_do.idw_Detail.RowCount()) = 0 Then
			llNewRow = dw_so.InsertRow(0)
			dw_so.SetITem(llNewRow,'sales_order',lsSO)
		End IF
		
	End IF
	
Next

dw_so.SetReDraw(True)
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_nike_show_so
boolean visible = false
integer x = 814
integer y = 1144
end type

type cb_ok from w_response_ancestor`cb_ok within w_nike_show_so
integer x = 379
integer y = 1168
end type

type dw_so from u_dw_ancestor within w_nike_show_so
integer x = 41
integer y = 40
integer width = 965
integer height = 1104
boolean bringtotop = true
string dataobject = "d_nike_show_so"
end type

