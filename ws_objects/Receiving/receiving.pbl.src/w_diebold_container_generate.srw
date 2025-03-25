$PBExportHeader$w_diebold_container_generate.srw
$PBExportComments$Generate Container ID's for Diebold
forward
global type w_diebold_container_generate from window
end type
type st_4 from statictext within w_diebold_container_generate
end type
type st_3 from statictext within w_diebold_container_generate
end type
type cb_copy from commandbutton within w_diebold_container_generate
end type
type st_1 from statictext within w_diebold_container_generate
end type
type sle_count from singlelineedit within w_diebold_container_generate
end type
type cb_generate from commandbutton within w_diebold_container_generate
end type
type dw_container from u_dw_ancestor within w_diebold_container_generate
end type
type cb_ok from commandbutton within w_diebold_container_generate
end type
end forward

global type w_diebold_container_generate from window
integer x = 823
integer y = 360
integer width = 1179
integer height = 1476
boolean titlebar = true
string title = "Diebold Container ID~'s"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 79741120
event ue_postopen ( )
st_4 st_4
st_3 st_3
cb_copy cb_copy
st_1 st_1
sle_count sle_count
cb_generate cb_generate
dw_container dw_container
cb_ok cb_ok
end type
global w_diebold_container_generate w_diebold_container_generate

type variables
str_parms	istrparms
Decimal	idRemain
Window	iwCurrent
end variables

event ue_postopen();Long	llPutawayPos, llPutawayCount, llCount, llPos


//Load any existing Container ID's already assigned on Putaway (PO_No2)
llPutawayCount = w_ro.idw_Putaway.RowCount()

If llPutawayCount > 0 Then
	
	For llPutawayPos = 1 to llPutawayCount
		
		If dw_container.RowCount() = 0 Then
			
			If w_ro.idw_Putaway.GetItemString(llPutawayPos,'po_no2') > '' and w_ro.idw_Putaway.GetItemString(llPutawayPos,'po_no2')  <> '-'  and + &
				 w_ro.idw_Putaway.GetItemString(llPutawayPos,'po_no2')  <> '0'  Then
				 
					dw_Container.InsertRow(0)
					dw_Container.SetItem(1,'container_id',w_ro.idw_Putaway.GetItemString(llPutawayPos,'po_no2'))
					
			End If
		
		Else
		
			If dw_Container.Find("Upper(container_id) = '" + Upper(w_ro.idw_Putaway.GetItemString(llPutawayPos,'po_no2')) + "'",1, dw_Container.RowCount()) = 0 Then
				
				dw_Container.InsertRow(0)
				dw_Container.SetItem(dw_Container.RowCount(),'container_id',w_ro.idw_Putaway.GetItemString(llPutawayPos,'po_no2'))
			
			End If
			
		End If
		
	Next /*Putaway Record */
	
End If


cb_copy.Enabled = False
end event

on w_diebold_container_generate.create
this.st_4=create st_4
this.st_3=create st_3
this.cb_copy=create cb_copy
this.st_1=create st_1
this.sle_count=create sle_count
this.cb_generate=create cb_generate
this.dw_container=create dw_container
this.cb_ok=create cb_ok
this.Control[]={this.st_4,&
this.st_3,&
this.cb_copy,&
this.st_1,&
this.sle_count,&
this.cb_generate,&
this.dw_container,&
this.cb_ok}
end on

on w_diebold_container_generate.destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.cb_copy)
destroy(this.st_1)
destroy(this.sle_count)
destroy(this.cb_generate)
destroy(this.dw_container)
destroy(this.cb_ok)
end on

event open;
istrparms = message.PowerobjectParm
iwCurrent = This

If not isvalid(w_ro) Then Close(this)

This.PostEvent("ue_postOpen")

end event

type st_4 from statictext within w_diebold_container_generate
integer x = 41
integer y = 1180
integer width = 827
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "~'Copy~' button to copy to Putaway"
boolean focusrectangle = false
end type

type st_3 from statictext within w_diebold_container_generate
integer x = 41
integer y = 1132
integer width = 978
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Double click a Container ID or click the "
boolean focusrectangle = false
end type

type cb_copy from commandbutton within w_diebold_container_generate
integer x = 475
integer y = 1260
integer width = 251
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Copy"
end type

event clicked;
If w_ro.Idw_Main.GetItemString(1,'ord_status') = 'C' or w_ro.Idw_Main.GetItemString(1,'ord_status') = 'V' Then Return

If w_ro.idw_Putaway.RowCount() = 0 Then Return

If w_ro.idw_Putaway.GetRow() = 0 Then Return

w_ro.Idw_Putaway.SetITem( w_ro.idw_Putaway.GetRow(),'po_no2',dw_container.getITemString(dw_Container.GetRow(),'container_id'))
w_ro.ib_changed = True
end event

type st_1 from statictext within w_diebold_container_generate
integer x = 585
integer y = 48
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Container ID~'s"
boolean focusrectangle = false
end type

type sle_count from singlelineedit within w_diebold_container_generate
integer x = 366
integer y = 32
integer width = 183
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_generate from commandbutton within w_diebold_container_generate
integer x = 37
integer y = 32
integer width = 293
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;Long	llPos, llMax, llPrefix
String	lsPrefix


//Prefix with char based on Warehouse Code
Choose Case w_ro.idw_Main.getITemString(1,'wh_Code')
		
	Case 'DIE-COLUMB'
		lsPrefix = 'C'
	Case 'DIE-PHX'
		lsPrefix = 'P'
	Case 'DIE-GREENS'
		lsPrefix = 'G'
	Case Else
		lsPrefix = 'X'
End Choose

If isnumber(sle_Count.Text) Then
	
	// Numeric part of the RO_NO will be the Container PRefix
	llPrefix = Long(Right(w_ro.idw_Main.GetITemString(1,'ro_no'),6))
	
	//Find The MAx already
	If dw_Container.RowCount() > 0 Then
		
		llMax = 0
		
		For llPos = 1 to dw_Container.RowCount()
			
			If IsNumber(dw_Container.GetItemString(llPos,'Container_ID')) Then
				If Long(dw_Container.GetItemString(llPos,'Container_ID')) > llMax Then
					llMax = Long(dw_Container.GetItemString(llPos,'Container_ID')) 
				End If
			End If
			
		Next
		
	Else
		llMax = 0
	End If
	
	For llPos = 1 to Long(Sle_Count.Text)
		
		dw_Container.InsertRow(0)
		
		llMax ++
		
		//Prefix with char based on Warehouse Code
		
		dw_Container.SetItem(dw_Container.RowCount(),'Container_id',lsPRefix + String(llPrefix,'000000') + Right(String(llMax,'0000'),4))
		
	Next
	
Else
	Messagebox("","Field must be numeric")
End If
end event

type dw_container from u_dw_ancestor within w_diebold_container_generate
integer x = 128
integer y = 164
integer width = 731
integer height = 960
string dataobject = "d_diebold_container_id"
boolean vscrollbar = true
end type

event constructor;//Ancestor being overridden

This.SetRowFocusIndicator(Hand!)
end event

event clicked;call super::clicked;
If This.GetRow() > 0 Then cb_Copy.Enabled = True
end event

event doubleclicked;call super::doubleclicked;
cb_copy.TriggerEvent('clicked')
end event

type cb_ok from commandbutton within w_diebold_container_generate
integer x = 137
integer y = 1264
integer width = 187
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;close(parent)
end event

