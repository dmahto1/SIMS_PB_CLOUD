$PBExportHeader$w_proc_asn_order.srw
$PBExportComments$- Process ASN by Order
forward
global type w_proc_asn_order from w_main_ancestor
end type
type dw_asn from u_dw_ancestor within w_proc_asn_order
end type
type cb_selectall from commandbutton within w_proc_asn_order
end type
type cb_clear from commandbutton within w_proc_asn_order
end type
type cb_apply from commandbutton within w_proc_asn_order
end type
type st_1 from statictext within w_proc_asn_order
end type
type st_order from statictext within w_proc_asn_order
end type
end forward

global type w_proc_asn_order from w_main_ancestor
integer width = 3410
integer height = 1496
string title = "Apply ASN"
event ue_selectall ( )
event ue_clear ( )
event ue_apply ( )
event type integer ue_save ( )
event ue_update ( )
dw_asn dw_asn
cb_selectall cb_selectall
cb_clear cb_clear
cb_apply cb_apply
st_1 st_1
st_order st_order
end type
global w_proc_asn_order w_proc_asn_order

type variables
Boolean	ibApplyASN, ibChanged

// pvh gmt 12/15/05
string isWarehouseCode
end variables

forward prototypes
private subroutine setwarehousecode (string _value)
private function string getwarehousecode ()
end prototypes

event ue_selectall;
long	llRowCOunt,	&
		llRowPos
		
dw_asn.SetRedraw(False)

llRowCOunt = dw_asn.RowCount()

For llRowPos = 1 to llRowCount
	dw_Asn.SetITem(llRowPos,'c_apply_ind','Y')
	dw_Asn.SetITem(llRowPos,'c_work_qty',dw_Asn.GetITemNUmber(llRowPos,'ship_qty'))
Next

dw_Asn.SetRedraw(True)

If llRowCount > 0 THen
	cb_apply.Enabled = True
End If
end event

event ue_clear;
long	llRowCOunt,	&
		llRowPos
		
dw_asn.SetRedraw(False)

llRowCOunt = dw_asn.RowCount()

For llRowPos = 1 to llRowCount
	dw_Asn.SetITem(llRowPos,'c_apply_ind','N')
Next

dw_Asn.SetRedraw(True)

cb_apply.Enabled = False
end event

event ue_apply;Long	llRowPos,	&
		llRowCount

Boolean	lbPrevApply
		
//If putaway has not already been generated, generate, otherwise apply ASN to existing Putaway

If isvalid(w_ro) Then
	
	//If any checked Rows have already been previously applied, confirm
	lbPrevApply = False
	llRowCount = dw_Asn.RowCount()
	For llRowPos = 1 to llRowCount
		If Dw_asn.GetITemString(llRowPos,'c_apply_ind') = 'Y' and Dw_asn.GetITemNumber(llRowPos,'rcv_qty') > 0 Then
			lbPrevApply = True
			Exit
		End If
	Next
	
	If lbPrevApply Then
		If MessageBox('ASN','1 or more checked rows have already been received.~r~rDo you wish to re-apply?',Question!,YesNo!,2) = 2 Then
			Return
		End If
	End If
	
	ibApplyASN = True
	w_ro.Triggerevent('ue_generate_putaway')
	If w_ro.idw_putaway.RowCOunt() > 0 Then
		ibChanged = True
	End If
		
Else /*w_ro Not open*/
	
	MessageBox('ASN','Receive Order must be open to process the ASN for this order.')
	
End If /* w_ro Open? */
end event

event type integer ue_save();Integer	liRC


//Update quantities and dates - may be called from w_ro as well.
THis.TriggerEvent('ue_update')

//Save the changes to Receive ORder
If isValid(w_ro) Then
	liRC = w_ro.TriggerEvent("ue_Save")
	If liRC < 0 THen
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox('ASN','Unable to save changes to Receive Order.~r~rASN changes will not be saved either.')
		Return -1
	End If
End If

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

liRC = dw_asn.Update()
If liRC < 0 Then
	MessageBox('ASN','Unable to Save changes to ASN records.')
	Execute Immediate "ROLLBACK" using SQLCA;
	Return -1
End If

Execute Immediate "COMMIT" using SQLCA;

Return 0



end event

event ue_update();Long	llRowPos,	&
		llRowCount
String	lsASNNo,	&
			lsAsnHold
			
// pvh gmt 12/15/05
//Date		ldToday
//ldToday = Today()
datetime ldtToday
ldtToday = f_getLocalWorldTime( getWarehouseCode() ) 

//Update Quantities and dates

llRowCount = dw_Asn.RowCOunt()
For llRowPos = 1 to llRowCount
	
	lsASnNo = dw_Asn.GetITemString(llRowPos,'asn_no')
	
	//If it's a new header, update the actual arrival date
	If lsASNNo <> lsASNHold Then
		
		Update asn_header set actual_arrival_date = :ldtToday
		Where	Project_id = :gs_project and asn_no = :lsasnNo;
		
		lsASnHold = lsASNNo
		
	End If
	
	//Move the entered Qty received (work_qty) to rcv qty in the DB for all checked Rows.
	If dw_Asn.GetItemString(llRowPos,'c_apply_ind') = 'Y' Then
		dw_Asn.SetItem(llRowPos,'rcv_qty',dw_Asn.GetITemNUmber(llRowPos,'c_work_qty'))
	End If
	
Next
end event

private subroutine setwarehousecode (string _value);// setWarehouseCode( string _value )

if isNull( _value ) then _value = ''
isWarehouseCode = _value

end subroutine

private function string getwarehousecode ();// string = getWarehouseCode()
return isWarehouseCode

end function

on w_proc_asn_order.create
int iCurrent
call super::create
this.dw_asn=create dw_asn
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.cb_apply=create cb_apply
this.st_1=create st_1
this.st_order=create st_order
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_asn
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.cb_apply
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_order
end on

on w_proc_asn_order.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_asn)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.cb_apply)
destroy(this.st_1)
destroy(this.st_order)
end on

event ue_postopen;call super::ue_postopen;
ibApplyASN = False
ibChanged = False
cb_apply.Enabled = False

//Retrieve the ASN for the selected Order
This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;
String	lsOrder,	&
			lsFind,	&
			lsSku
			
Long		llRowCount,	&
			llRowPos,	&
			llDetailRowPos,	&
			llDetailRowCount,	&
			llLineItem

lsOrder = IstrParms.String_arg[1] /*Order NUmber passed from W_RO*/
st_order.Text = lsOrder
llRowCount = dw_asn.Retrieve(gs_project,lsOrder)

If llRowCount <=0 Then
	Messagebox('ASN','There are no ASN records for this order')
End If







end event

event open;call super::open;
IstrParms = Message.PowerObjectParm

// pvh gmt 12/15/05
if UpperBound(  IstrParms.String_arg ) > 1 then
	setWarehouseCode(  IstrParms.String_arg[2] )
end if


end event

event closequery;call super::closequery;Integer	liRC

If ibchanged Then
	Choose Case Messagebox('ASN',"Save changes?",Question!,yesnocancel!,1)
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

event resize;call super::resize;dw_asn.Resize(workspacewidth() - 80,workspaceHeight()-200)

//Keep the buttons at the bottom
cb_selectall.Move(cb_selectall.x,(workspaceHeight()-90))
cb_apply.Move(cb_apply.x,(workspaceHeight()-90))
cb_clear.Move(cb_clear.x,(workspaceHeight()-90))
cb_ok.Move(cb_ok.x,(workspaceHeight()-90))
cb_cancel.Move(cb_cancel.x,(workspaceHeight()-90))
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_proc_asn_order
integer x = 2190
integer y = 1216
integer height = 84
integer textsize = -8
integer weight = 400
end type

type cb_ok from w_main_ancestor`cb_ok within w_proc_asn_order
integer x = 1810
integer y = 1216
integer height = 84
integer textsize = -8
integer weight = 400
end type

type dw_asn from u_dw_ancestor within w_proc_asn_order
event ue_check_apply ( )
integer x = 9
integer y = 96
integer width = 3342
integer height = 1096
boolean bringtotop = true
string dataobject = "d_asn_order"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_check_apply;
If THis.Find("c_apply_ind = 'Y'",1,This.RowCOunt()) > 0 Then
	cb_apply.Enabled = True
Else
	cb_apply.Enabled = FAlse
End If
end event

event itemchanged;call super::itemchanged;String	lsFind
Long		llFindRow
Boolean	lbFirst

lbFirst = False

//enable or disable Apply button if any boxes checked.

If dwo.Name = "c_apply_ind" Then
	
	If data = 'Y' Then 
		
		This.SetItem(row,'c_work_qty',This.GEtITemNumber(row,'ship_qty')) /*default qty to rcv to shipped QTY*/
		
		//If this is the first box for a shipment/container, check all subsequent for the same
		lsFind = "Upper(Shipment_id) = '" + Upper(this.GetITemString(row,'shipment_id')) 
		lsFind += "' and Upper(container_id) = '" + Upper(this.GetITemString(row,'container_id')) + "'"

		If row = 1 Then
			lbFirst = true
		ElseIf This.Find(lsFind,(row - 1),1) = 0 Then
			lbFirst = True
		End If
				
		If lbFirst Then /*first row for container*/
		
			llFindRow = This.Find(lsFind,row,this.RowCOunt())
			Do While llFindRow > 0
				This.SetItem(llFindRow,'c_apply_ind','Y')
				llFindRow ++
				If llFindRow > THis.RowCOunt() Then
					llFindRow = 0
				Else
					llFindRow = This.Find(lsFind,llFindRow,this.RowCOunt())
					End If
			Loop
			
		End If /*first row for container*/
		
	Else /*unchecked*/
		
		This.SetItem(row,'c_work_qty',0)
		
	End If
	
	This.PostEvent("ue_Check_Apply")
	
End If
end event

type cb_selectall from commandbutton within w_proc_asn_order
integer x = 46
integer y = 1216
integer width = 297
integer height = 84
integer taborder = 30
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

type cb_clear from commandbutton within w_proc_asn_order
integer x = 407
integer y = 1216
integer width = 325
integer height = 84
integer taborder = 40
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

type cb_apply from commandbutton within w_proc_asn_order
integer x = 1147
integer y = 1216
integer width = 343
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Apply"
end type

event clicked;
Parent.TriggerEvent('ue_apply')



end event

type st_1 from statictext within w_proc_asn_order
integer x = 78
integer y = 16
integer width = 224
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Order:"
boolean focusrectangle = false
end type

type st_order from statictext within w_proc_asn_order
integer x = 293
integer y = 16
integer width = 1499
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

