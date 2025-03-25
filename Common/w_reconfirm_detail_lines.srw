HA$PBExportHeader$w_reconfirm_detail_lines.srw
$PBExportComments$- Process ASN by Order
forward
global type w_reconfirm_detail_lines from w_response_ancestor
end type
type st_instructions from statictext within w_reconfirm_detail_lines
end type
type dw_detail_select from u_dw_ancestor within w_reconfirm_detail_lines
end type
type cb_selectall from commandbutton within w_reconfirm_detail_lines
end type
type cb_clear from commandbutton within w_reconfirm_detail_lines
end type
end forward

global type w_reconfirm_detail_lines from w_response_ancestor
integer width = 4709
integer height = 2172
string title = "Select Re-Confirm Records"
boolean controlmenu = false
boolean center = true
event ue_selectall ( )
event ue_clear ( )
st_instructions st_instructions
dw_detail_select dw_detail_select
cb_selectall cb_selectall
cb_clear cb_clear
end type
global w_reconfirm_detail_lines w_reconfirm_detail_lines

type variables


inet	linit



String is_Type

Boolean	ibApplyASN, ibChanged

// pvh gmt 12/15/05
string isWarehouseCode
end variables

event ue_selectall();
long	llRowCOunt,	&
		llRowPos
		
dw_detail_select.SetRedraw(False)

llRowCOunt = dw_detail_select.RowCount()

For llRowPos = 1 to llRowCount
	dw_detail_select.SetITem(llRowPos,'reconfirm_ind','Y')
Next

dw_detail_select.SetRedraw(True)


end event

event ue_clear();
long	llRowCOunt,	&
		llRowPos
		
dw_detail_select.SetRedraw(False)

llRowCOunt = dw_detail_select.RowCount()

For llRowPos = 1 to llRowCount
	dw_detail_select.SetITem(llRowPos,'reconfirm_ind','N')
Next

dw_detail_select.SetRedraw(True)


end event

on w_reconfirm_detail_lines.create
int iCurrent
call super::create
this.st_instructions=create st_instructions
this.dw_detail_select=create dw_detail_select
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_instructions
this.Control[iCurrent+2]=this.dw_detail_select
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
end on

on w_reconfirm_detail_lines.destroy
call super::destroy
destroy(this.st_instructions)
destroy(this.dw_detail_select)
destroy(this.cb_selectall)
destroy(this.cb_clear)
end on

event open;call super::open;//TimA 04/16/14
String lsDefaultInstructions
String lsDetailObject

IstrParms = Message.PowerObjectParm


lsDetailObject = IstrParms.String_arg[2 ] 

Choose case lsDetailObject

	Case 'INBOUND'
		dw_detail_select.dataobject = 'd_ro_detail_reconfirm'

	Case 'OUTBOUND'
		dw_detail_select.dataobject = 'd_do_detail_reconfirm'
	Case 'SOC'
		dw_detail_select.dataobject = 'd_owner_change_detail_reconfirm'
End Choose
dw_detail_select.SetTransObject(sqlca)

lsDefaultInstructions = 'Please select the detail records you want to re-confirm. '

this.st_instructions.text = lsDefaultInstructions

end event

event ue_postopen;call super::ue_postopen;
This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;
String	lsSystemNo
Long llRowCount
			
lsSystemNo = IstrParms.String_arg[1] 

llRowCount = dw_detail_select.Retrieve(lsSystemNo )

If llRowCount <=0 Then
	Messagebox('No Records','There are no detail records for this order')
End If

end event

event ue_preopen;call super::ue_preopen;//
//String lsDetailObject
//lsDetailObject = IstrParms.String_arg[2 ] 
//

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_reconfirm_detail_lines
integer x = 4379
integer y = 1964
integer taborder = 60
end type

event cb_cancel::clicked;// DON'T!!   "Extent the Ancestor Script"

istrparms.string_arg_2[1 ] = ''
CloseWithReturn(parent, istrparms )
	

end event

type cb_ok from w_response_ancestor`cb_ok within w_reconfirm_detail_lines
integer x = 4082
integer y = 1964
integer taborder = 50
string text = "Ok"
boolean default = false
end type

event cb_ok::clicked;// DON'T!!   "Extent the Ancestor Script"

Long llRowCount, llRowPos, ll_Line, ll_SelectCount
String lsRowsSelected


llRowCount =  dw_detail_select.Rowcount()
For llRowPos = 1 to llRowCount
	If dw_detail_select.GetItemString(llRowPOs,'reconfirm_ind' ) = 'Y' then
		ll_SelectCount ++
		ll_Line = dw_detail_select.GetItemNumber(llRowPOs,'line_item_no' )
		If ll_SelectCount > 1 then
		
			lsRowsSelected = lsRowsSelected + ',' + String(ll_Line)
		Else
			lsRowsSelected =  lsRowsSelected + String(ll_Line)
		End if
		istrparms.string_arg_2[1 ] =  lsRowsSelected

	End if
Next

If ll_SelectCount = llRowCount then
	//No need to delimit the results if all the records are selected
	istrparms.string_arg_2[1 ] = 'ALL'
Elseif	ll_SelectCount = 0 Then
	istrparms.string_arg_2[1 ] = 'NONE'
End if


CloseWithReturn(parent, istrparms  )
	

end event

type st_instructions from statictext within w_reconfirm_detail_lines
integer x = 41
integer y = 60
integer width = 3438
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "instructions"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_detail_select from u_dw_ancestor within w_reconfirm_detail_lines
event ue_check_apply ( )
integer x = 50
integer y = 212
integer width = 4613
integer height = 1700
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type cb_selectall from commandbutton within w_reconfirm_detail_lines
integer x = 50
integer y = 1964
integer width = 297
integer height = 84
integer taborder = 40
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

type cb_clear from commandbutton within w_reconfirm_detail_lines
integer x = 361
integer y = 1964
integer width = 325
integer height = 84
integer taborder = 50
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

