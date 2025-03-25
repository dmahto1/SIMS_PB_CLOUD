$PBExportHeader$w_sn_change.srw
$PBExportComments$-Stock Adjustment Program
forward
global type w_sn_change from window
end type
type st_5 from statictext within w_sn_change
end type
type st_4 from statictext within w_sn_change
end type
type st_3 from statictext within w_sn_change
end type
type st_2 from statictext within w_sn_change
end type
type cb_validate from commandbutton within w_sn_change
end type
type cb_clear_delivery_order_records_selected from commandbutton within w_sn_change
end type
type dw_sn_change_for_soc_child from u_dw_ancestor within w_sn_change
end type
type cb_2 from commandbutton within w_sn_change
end type
type cb_search from commandbutton within w_sn_change
end type
type cb_clear_recieved from commandbutton within w_sn_change
end type
type st_1 from statictext within w_sn_change
end type
type st_current from statictext within w_sn_change
end type
type st_confirm_serial_numbers from statictext within w_sn_change
end type
type st_child_serial_numbers from statictext within w_sn_change
end type
type sle_confirm_current_serial_number from singlelineedit within w_sn_change
end type
type sle_confirm_new_serial_number from singlelineedit within w_sn_change
end type
type sle_new_serial_number from singlelineedit within w_sn_change
end type
type sle_current_serial_number from singlelineedit within w_sn_change
end type
type cb_clear from commandbutton within w_sn_change
end type
type cb_undo from commandbutton within w_sn_change
end type
type cb_update from commandbutton within w_sn_change
end type
type dw_report from datawindow within w_sn_change
end type
type cb_report from commandbutton within w_sn_change
end type
type cb_clear_all from commandbutton within w_sn_change
end type
type dw_sn_change_for_receive_order_child from u_dw_ancestor within w_sn_change
end type
type dw_search from datawindow within w_sn_change
end type
type r_1 from rectangle within w_sn_change
end type
type r_2 from rectangle within w_sn_change
end type
type r_3 from rectangle within w_sn_change
end type
type r_4 from rectangle within w_sn_change
end type
type r_5 from rectangle within w_sn_change
end type
type dw_sn_change_for_delivery_order_child from u_dw_ancestor within w_sn_change
end type
end forward

global type w_sn_change from window
integer x = 5
integer y = 4
integer width = 4727
integer height = 3320
boolean titlebar = true
string title = "Fix Invalid Child Serial Number(s)"
string menuname = "m_simple_record"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
long backcolor = 67108864
event ue_delete ( )
event ue_new ( )
event type long ue_save ( )
event ue_retrieve ( )
event ue_print ( )
event ue_edit ( )
event ue_help ( )
event ue_sort ( )
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
cb_validate cb_validate
cb_clear_delivery_order_records_selected cb_clear_delivery_order_records_selected
dw_sn_change_for_soc_child dw_sn_change_for_soc_child
cb_2 cb_2
cb_search cb_search
cb_clear_recieved cb_clear_recieved
st_1 st_1
st_current st_current
st_confirm_serial_numbers st_confirm_serial_numbers
st_child_serial_numbers st_child_serial_numbers
sle_confirm_current_serial_number sle_confirm_current_serial_number
sle_confirm_new_serial_number sle_confirm_new_serial_number
sle_new_serial_number sle_new_serial_number
sle_current_serial_number sle_current_serial_number
cb_clear cb_clear
cb_undo cb_undo
cb_update cb_update
dw_report dw_report
cb_report cb_report
cb_clear_all cb_clear_all
dw_sn_change_for_receive_order_child dw_sn_change_for_receive_order_child
dw_search dw_search
r_1 r_1
r_2 r_2
r_3 r_3
r_4 r_4
r_5 r_5
dw_sn_change_for_delivery_order_child dw_sn_change_for_delivery_order_child
end type
global w_sn_change w_sn_change

type variables
m_simple_record im_menu
Boolean ib_changed
boolean ib_start_from_first
boolean ib_start_to_first
String is_title,i_sql, is_process
long	ilProcessRow, ilHelpTopicID
n_warehouse i_nwarehouse
str_parms	istrparms

String is_UndoCurrentSerialNumber, is_UndoNewSerialNumber


end variables

forward prototypes
public function integer wf_settaborder (integer a_ind)
end prototypes

event type long ue_save();

Return 0
end event

public function integer wf_settaborder (integer a_ind);Return 1
end function

on w_sn_change.create
if this.MenuName = "m_simple_record" then this.MenuID = create m_simple_record
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.cb_validate=create cb_validate
this.cb_clear_delivery_order_records_selected=create cb_clear_delivery_order_records_selected
this.dw_sn_change_for_soc_child=create dw_sn_change_for_soc_child
this.cb_2=create cb_2
this.cb_search=create cb_search
this.cb_clear_recieved=create cb_clear_recieved
this.st_1=create st_1
this.st_current=create st_current
this.st_confirm_serial_numbers=create st_confirm_serial_numbers
this.st_child_serial_numbers=create st_child_serial_numbers
this.sle_confirm_current_serial_number=create sle_confirm_current_serial_number
this.sle_confirm_new_serial_number=create sle_confirm_new_serial_number
this.sle_new_serial_number=create sle_new_serial_number
this.sle_current_serial_number=create sle_current_serial_number
this.cb_clear=create cb_clear
this.cb_undo=create cb_undo
this.cb_update=create cb_update
this.dw_report=create dw_report
this.cb_report=create cb_report
this.cb_clear_all=create cb_clear_all
this.dw_sn_change_for_receive_order_child=create dw_sn_change_for_receive_order_child
this.dw_search=create dw_search
this.r_1=create r_1
this.r_2=create r_2
this.r_3=create r_3
this.r_4=create r_4
this.r_5=create r_5
this.dw_sn_change_for_delivery_order_child=create dw_sn_change_for_delivery_order_child
this.Control[]={this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.cb_validate,&
this.cb_clear_delivery_order_records_selected,&
this.dw_sn_change_for_soc_child,&
this.cb_2,&
this.cb_search,&
this.cb_clear_recieved,&
this.st_1,&
this.st_current,&
this.st_confirm_serial_numbers,&
this.st_child_serial_numbers,&
this.sle_confirm_current_serial_number,&
this.sle_confirm_new_serial_number,&
this.sle_new_serial_number,&
this.sle_current_serial_number,&
this.cb_clear,&
this.cb_undo,&
this.cb_update,&
this.dw_report,&
this.cb_report,&
this.cb_clear_all,&
this.dw_sn_change_for_receive_order_child,&
this.dw_search,&
this.r_1,&
this.r_2,&
this.r_3,&
this.r_4,&
this.r_5,&
this.dw_sn_change_for_delivery_order_child}
end on

on w_sn_change.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_validate)
destroy(this.cb_clear_delivery_order_records_selected)
destroy(this.dw_sn_change_for_soc_child)
destroy(this.cb_2)
destroy(this.cb_search)
destroy(this.cb_clear_recieved)
destroy(this.st_1)
destroy(this.st_current)
destroy(this.st_confirm_serial_numbers)
destroy(this.st_child_serial_numbers)
destroy(this.sle_confirm_current_serial_number)
destroy(this.sle_confirm_new_serial_number)
destroy(this.sle_new_serial_number)
destroy(this.sle_current_serial_number)
destroy(this.cb_clear)
destroy(this.cb_undo)
destroy(this.cb_update)
destroy(this.dw_report)
destroy(this.cb_report)
destroy(this.cb_clear_all)
destroy(this.dw_sn_change_for_receive_order_child)
destroy(this.dw_search)
destroy(this.r_1)
destroy(this.r_2)
destroy(this.r_3)
destroy(this.r_4)
destroy(this.r_5)
destroy(this.dw_sn_change_for_delivery_order_child)
end on

event open;sle_current_serial_number.SetFocus()
end event

type st_5 from statictext within w_sn_change
integer x = 3003
integer y = 560
integer width = 1509
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Click Undo to Undo last Confirmed fix"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sn_change
integer x = 3003
integer y = 460
integer width = 1504
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Verify all valid serail numbers are ready and click Confirm"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sn_change
integer x = 3003
integer y = 360
integer width = 1152
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Enter valid serial number and click Input"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sn_change
integer x = 3003
integer y = 260
integer width = 1152
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Enter invalid serial number and click Search"
boolean focusrectangle = false
end type

type cb_validate from commandbutton within w_sn_change
integer x = 2619
integer y = 348
integer width = 352
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Validate"
boolean cancel = true
end type

event clicked;String ls_CurrentSerialNumber, s_ConfirmCurrentSerialNumber
Integer li_Row_Count, li_Row_Counter

sle_confirm_new_serial_number.text = sle_new_serial_number.text 

If NOT (Trim( sle_new_serial_number.text )  					= '' or IsNull( sle_new_serial_number.text ))				Then
	
	If NOT (Trim(sle_confirm_new_serial_number.text  )		= '' or IsNull( sle_confirm_new_serial_number.text )) 	Then

		If sle_new_serial_number.text = sle_confirm_new_serial_number.text Then
	
			cb_validate.enabled  = False
			
			If dw_sn_change_for_receive_order_child.RowCount() > 0 then
				
				li_Row_Count = dw_sn_change_for_receive_order_child.RowCount()
				
				For  li_Row_Counter = 1 to li_Row_Count
					
					dw_sn_change_for_receive_order_child.SetItem(  li_Row_Counter, "Serial_No",  sle_new_serial_number.text  )
					
				Next
				
			End If
			
			If dw_sn_change_for_soc_child.RowCount() > 0 then
				
				li_Row_Count = dw_sn_change_for_soc_child.RowCount()
				
				For  li_Row_Counter = 1 to li_Row_Count
					
					dw_sn_change_for_soc_child.SetItem(  li_Row_Counter, "Serial_No_Child",  	sle_new_serial_number.text  )
					
				Next
				
			End If
			
			If dw_sn_change_for_delivery_order_child.RowCount() > 0 then
				
				li_Row_Count = dw_sn_change_for_delivery_order_child.RowCount()
				
				For  li_Row_Counter = 1 to li_Row_Count
					
					dw_sn_change_for_delivery_order_child.SetItem(  li_Row_Counter, "Serial_No",  sle_new_serial_number.text  )
					
				Next
							
			End If
			
			cb_update.Enabled 					=TRUE
			sle_new_serial_number.Enabled 	= FALSE
			
		Else

			MessageBox( "Child Serial Number Change", " New Child Serial Number DOES NOT MATCH New Confirm Serial Number!~r~r~r                                        PLEASE REENTER" )
			sle_new_serial_number.SetFocus()
			sle_new_serial_number.SelectText(1,LEN(sle_new_serial_number.text))
		End If

	Else
		
			MessageBox( "Child Serial Number Change", " Child Serial Numbers CANNOT BE BLANK or NULL! !~r~r                 PLEASE REENTER!" )
			sle_confirm_new_serial_number.SetFocus()
			sle_confirm_new_serial_number.SelectText(1,LEN(sle_confirm_new_serial_number.text ))
			
	End If
		
Else
	
			MessageBox( "Child Serial Number Change", " Child Serial Numbers CANNOT BE BLANK or NULL!~r~r                PLEASE REENTER! " )
			sle_new_serial_number.SetFocus()
			sle_new_serial_number.SelectText(1,LEN(sle_new_serial_number.text ))
	
End If		                   
end event

type cb_clear_delivery_order_records_selected from commandbutton within w_sn_change
boolean visible = false
integer x = 59
integer y = 2296
integer width = 1239
integer height = 88
integer taborder = 70
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear Delivery &Order Records Selected "
boolean cancel = true
end type

event clicked;Integer li_Row_count

If cb_update.enabled 	= TRUE Then

	If dw_sn_change_for_delivery_order_child.RowCount() > 0 Then
	
		For  li_Row_count = 1 to dw_sn_change_for_delivery_order_child.RowCount()
			dw_sn_change_for_delivery_order_child.SetItem(li_Row_count, "Serial_No",dw_sn_change_for_delivery_order_child.GetItemString( li_Row_count,"CurrentSerialNumber"))
		Next
	
	End If
	
Else	
	
	If cb_validate.enabled 	= TRUE Then
		
		sle_new_serial_number.SelectText(1 , Len(TRIM(sle_new_serial_number.Text )))	
		sle_new_serial_number.SetFocus()
		
	Else
		
		If cb_search.enabled 	= TRUE Then
			
			sle_current_serial_number.SelectText(1 , Len(TRIM(sle_current_serial_number.Text )))	
			sle_current_serial_number.SetFocus()
			
		End If
		
	End If
	
	
End If


end event

type dw_sn_change_for_soc_child from u_dw_ancestor within w_sn_change
integer x = 32
integer y = 1492
integer width = 4535
integer height = 772
integer taborder = 70
boolean titlebar = true
string title = "Stock Owner Changes with this Serial Number"
string dataobject = "d_sn_change_for_soc_child"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event clicked;String ls_OldSerialNumber, ls_NewSerialNumber

If row > 0 and cb_validate.Enabled  = FALSE Then
	
	 ls_OldSerialNumber		=	dw_sn_change_for_soc_child.GetItemString( row, "CurrentSerialNumber")
	 ls_NewSerialNumber		=	dw_sn_change_for_soc_child.GetItemString( row, "Serial_No_Child")	

	If ls_OldSerialNumber	 = ls_NewSerialNumber Then
		dw_sn_change_for_soc_child.SetItem( row, "Serial_No_Child", sle_new_serial_number.text )
		cb_update.enabled   = TRUE
	Else
		dw_sn_change_for_soc_child.SetItem( row, "Serial_No_Child", dw_sn_change_for_soc_child.GetItemString( row, "CurrentSerialNumber"))	
	End If

End If



end event

event itemerror;Return 1
end event

type cb_2 from commandbutton within w_sn_change
boolean visible = false
integer x = 59
integer y = 1476
integer width = 1239
integer height = 88
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear Stock &Owner Change Records Selected"
boolean cancel = true
end type

event clicked;Integer li_Row_count

If cb_update.enabled 	= TRUE Then
	
	If dw_sn_change_for_soc_child.RowCount() > 0 Then
	
		For  li_Row_count = 1 to dw_sn_change_for_soc_child.RowCount()
			dw_sn_change_for_soc_child.SetItem(li_Row_count, "Serial_No_Child",dw_sn_change_for_soc_child.GetItemString( li_Row_count,"CurrentSerialNumber"))
		Next
	
	End If
	
Else	
	
	If cb_validate.enabled 	= TRUE Then
		
		sle_new_serial_number.SelectText(1 , Len(TRIM(sle_new_serial_number.Text )))	
		sle_new_serial_number.SetFocus()
		
	Else
		
		If cb_search.enabled 	= TRUE Then
			
			sle_current_serial_number.SelectText(1 , Len(TRIM(sle_current_serial_number.Text )))	
			sle_current_serial_number.SetFocus()
			
		End If
		
	End If	
	
End If


end event

type cb_search from commandbutton within w_sn_change
integer x = 2619
integer y = 244
integer width = 352
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean cancel = true
end type

event clicked;String ls_CurrentSerialNumber, s_ConfirmCurrentSerialNumber

SetPointer( HourGlass!)

sle_confirm_current_serial_number.text  = sle_current_serial_number.text 

If NOT (Trim( sle_current_serial_number.text )  					= '' or IsNull( sle_current_serial_number.text ))				Then
	
	If NOT (Trim( sle_confirm_current_serial_number.text  )		= '' or IsNull( sle_confirm_current_serial_number.text )) 	Then

		If sle_current_serial_number.text = sle_confirm_current_serial_number.text Then
	
			dw_sn_change_for_soc_child.retrieve( 	 			sle_current_serial_number.text  )
			dw_sn_change_for_receive_order_child.retrieve(  sle_current_serial_number.text  )
			dw_sn_change_for_delivery_order_child.retrieve( 	sle_current_serial_number.text  )
	
			If  (	dw_sn_change_for_soc_child.RowCount() + dw_sn_change_for_receive_order_child.RowCount() + &
					dw_sn_change_for_delivery_order_child.RowCount()	) = 0 Then
		
					MessageBox( "Child Serial Number Change", " No Records Exist For The Specified Child Serial Number " )
					sle_current_serial_number.SetFocus()
					sle_current_serial_number.SelectText(1,LEN(sle_current_serial_number.text ))
			Else
			
					cb_search.enabled 	= FALSE
					cb_validate.enabled 	= TRUE
			
					sle_current_serial_number.enabled   				= FALSE
					sle_confirm_current_serial_number.enabled  	= FALSE
			
					sle_new_serial_number.enabled  				= TRUE
					sle_confirm_new_serial_number.enabled 	= TRUE
					
					sle_new_serial_number.SetFocus()
			
			End If
		Else

			MessageBox( "Child Serial Number Change", " Current Child Serial Number DOES NOT MATCH Current Confirm Serial Number!~r ~r~r                                        PLEASE REENTER!" )
			sle_current_serial_number.SetFocus()

		End If

	Else
		
			MessageBox( "Child Serial Number Change", " Child Serial Numbers CANNOT BE BLANK or NULL! !~r~r                 PLEASE REENTER!" )
			sle_confirm_current_serial_number.SetFocus()
			sle_confirm_current_serial_number.SelectText(1,LEN(sle_confirm_current_serial_number.text ))
			
	End If
		
Else
	
			MessageBox( "Child Serial Number Change", " Child Serial Numbers CANNOT BE BLANK or NULL!~r~r                PLEASE REENTER! " )
			sle_current_serial_number.SetFocus()
			sle_current_serial_number.SelectText(1,LEN(sle_current_serial_number.text ))
	
End If	
end event

type cb_clear_recieved from commandbutton within w_sn_change
boolean visible = false
integer x = 59
integer y = 656
integer width = 1239
integer height = 88
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear &Recieved Order Records Selected"
boolean cancel = true
end type

event clicked;Integer li_Row_count

If cb_update.enabled 	=TRUE Then
	
	If dw_sn_change_for_receive_order_child.RowCount() > 0 Then
	
		For  li_Row_count = 1 to dw_sn_change_for_receive_order_child.RowCount()
			dw_sn_change_for_receive_order_child.SetItem(li_Row_count, "Serial_No",dw_sn_change_for_receive_order_child.GetItemString( li_Row_count,"CurrentSerialNumber"))
		Next
	
	End If
	
Else	
	
	If cb_validate.enabled 	= TRUE Then
		
		sle_new_serial_number.SelectText(1 , Len(TRIM(sle_new_serial_number.Text )))	
		sle_new_serial_number.SetFocus()
		
	Else
		
		If cb_search.enabled 	= TRUE Then
			
			sle_current_serial_number.SelectText(1 , Len(TRIM(sle_current_serial_number.Text )))	
			sle_current_serial_number.SetFocus()
			
		End If
		
	End If
	
End If
end event

type st_1 from statictext within w_sn_change
integer x = 1321
integer y = 420
integer width = 1042
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
string text = "                                Valid                                "
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_current from statictext within w_sn_change
integer x = 247
integer y = 420
integer width = 1033
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 134217737
string text = "                           Invalid                           "
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_confirm_serial_numbers from statictext within w_sn_change
boolean visible = false
integer x = 59
integer y = 456
integer width = 709
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "CONFIRM SERIAL NUMBER:"
boolean focusrectangle = false
end type

type st_child_serial_numbers from statictext within w_sn_change
integer x = 992
integer y = 328
integer width = 594
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Child SERIAL NUMBER:"
boolean focusrectangle = false
end type

type sle_confirm_current_serial_number from singlelineedit within w_sn_change
boolean visible = false
integer x = 786
integer y = 472
integer width = 1033
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event getfocus;sle_confirm_current_serial_number.SetFocus()
sle_confirm_current_serial_number.SelectText(1,LEN(sle_confirm_current_serial_number.text ))


end event

type sle_confirm_new_serial_number from singlelineedit within w_sn_change
boolean visible = false
integer x = 1874
integer y = 540
integer width = 1033
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;sle_confirm_new_serial_number.SetFocus()
sle_confirm_new_serial_number.SelectText(1,LEN(sle_confirm_new_serial_number.text))
end event

type sle_new_serial_number from singlelineedit within w_sn_change
integer x = 1321
integer y = 480
integer width = 1033
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event getfocus;sle_new_serial_number.SetFocus()
sle_new_serial_number.SelectText(1,LEN(sle_new_serial_number.text))
end event

type sle_current_serial_number from singlelineedit within w_sn_change
integer x = 247
integer y = 480
integer width = 1033
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dragwithin;sle_current_serial_number.SetFocus()
sle_current_serial_number.SelectText(1,LEN(sle_current_serial_number.text ))
end event

type cb_clear from commandbutton within w_sn_change
integer x = 59
integer y = 48
integer width = 352
integer height = 88
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear / Next"
end type

event clicked;sle_current_serial_number.Enabled 				= True
sle_confirm_current_serial_number.Enabled 	= True

sle_current_serial_number.text =''
sle_confirm_current_serial_number.text = '' 


sle_new_serial_number.Enabled 				= False
sle_confirm_new_serial_number.Enabled 	= FAlse

sle_new_serial_number.text = ''
sle_confirm_new_serial_number.text = ''

cb_search.Enabled 	= 	True
cb_validate.Enabled 	=	False
cb_update.Enabled 	= 	False

dw_sn_change_for_receive_order_child.Reset()
dw_sn_change_for_soc_child.Reset()
dw_sn_change_for_delivery_order_child.Reset()

sle_current_serial_number.SetFocus()
sle_current_serial_number.SelectText(1,LEN(sle_current_serial_number.text ))
end event

type cb_undo from commandbutton within w_sn_change
integer x = 2619
integer y = 556
integer width = 352
integer height = 88
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "U&ndo"
end type

event clicked;dw_sn_change_for_soc_child.retrieve(  				is_UndoCurrentSerialNumber 	)
dw_sn_change_for_receive_order_child.retrieve(  is_UndoCurrentSerialNumber 	)
dw_sn_change_for_delivery_order_child.retrieve( is_UndoCurrentSerialNumber  	)

If ( dw_sn_change_for_soc_child.RowCount() + dw_sn_change_for_receive_order_child.RowCount() + &
	 dw_sn_change_for_delivery_order_child.RowCount() ) > 0  Then

	sle_current_serial_number.Enabled 				= FALSE
	sle_confirm_current_serial_number.Enabled 	= FALSE

	sle_new_serial_number.Enabled 			 	= TRUE
	sle_confirm_new_serial_number.Enabled 	= TRUE

	sle_current_serial_number.text				=  	is_UndoCurrentSerialNumber
	sle_confirm_current_serial_number.text	=  	is_UndoCurrentSerialNumber
	
	sle_new_serial_number.text					= 	is_UndoNewSerialNumber
	sle_confirm_new_serial_number.text		= 	is_UndoNewSerialNumber


	cb_search.Enabled 					= FALSE
	cb_validate.Enabled	  				= TRUE
	sle_new_serial_number.Enabled  	= FALSE
	
	cb_update.Enabled    = FALSE
	
	cb_undo.Enabled = False
	
Else
	MessageBox( "Child Serial Number Change", "Unable to Undo Child Serial Record(s).~r~r~r           Record(s) could Not be Located!")
	
	
	sle_current_serial_number.Enabled 				= TRUE
	sle_confirm_current_serial_number.Enabled 	= TRUE

	sle_new_serial_number.Enabled 			 	= FALSE
	sle_confirm_new_serial_number.Enabled 	= FALSE

	sle_current_serial_number.text				=  ""
	sle_confirm_current_serial_number.text	= ""
	
	sle_current_serial_number.SetFocus()	        

	sle_new_serial_number.text					=  ""
	sle_confirm_new_serial_number.text		= ""
	
	cb_search.Enabled 	= TRUE
	cb_validate.enabled 	= FALSE
	
	cb_undo.Enabled = FALSE
	
End If
end event

type cb_update from commandbutton within w_sn_change
integer x = 2619
integer y = 452
integer width = 352
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Update"
end type

event clicked;dw_sn_change_for_soc_child.Update()
dw_sn_change_for_receive_order_child.Update()
dw_sn_change_for_delivery_order_child.Update()
	
is_UndoCurrentSerialNumber   	= sle_new_serial_number.text
is_UndoNewSerialNumber		= sle_current_serial_number.text

cb_undo.Enabled 		= TRUE
cb_update. Enabled 	= FALSE
cb_search.Enabled 	= TRUE

dw_sn_change_for_receive_order_child.Reset()
dw_sn_change_for_soc_child.Reset()
dw_sn_change_for_delivery_order_child.Reset()

sle_new_serial_number.Enabled 			 	= FALSE
sle_confirm_new_serial_number.Enabled 	= FALSE

sle_current_serial_number.Enabled 			 	= TRUE
sle_confirm_current_serial_number.Enabled 	= TRUE

sle_new_serial_number.text = ""
sle_confirm_new_serial_number.text = ""

sle_current_serial_number.text = ""
sle_confirm_current_serial_number.text = ""

sle_current_serial_number.SetFocus()

end event

type dw_report from datawindow within w_sn_change
boolean visible = false
integer x = 2281
integer y = 1760
integer width = 494
integer height = 360
integer taborder = 60
string dataobject = "d_adjustment_report"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_report from commandbutton within w_sn_change
boolean visible = false
integer x = 2898
integer y = 64
integer width = 722
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print  Report"
end type

event clicked;//IF dw_report.Rowcount() > 0 THEN
// OpenWithParm(w_dw_print_options,dw_report)
//ELSE
//	Messagebox(is_title,"Nothing to Print")
//END IF 
end event

type cb_clear_all from commandbutton within w_sn_change
boolean visible = false
integer x = 1445
integer y = 656
integer width = 750
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear &All Records Selected"
end type

event clicked;Integer li_Row_count

If cb_update.enabled 	= TRUE Then

	If dw_sn_change_for_receive_order_child.RowCount() > 0 Then
	
		For  li_Row_count = 1 to dw_sn_change_for_receive_order_child.RowCount()
			dw_sn_change_for_receive_order_child.SetItem(li_Row_count, "Serial_No",dw_sn_change_for_receive_order_child.GetItemString( li_Row_count,"CurrentSerialNumber"))
		Next
	
	End If



	If dw_sn_change_for_soc_child.RowCount() > 0 Then
	
		For  li_Row_count = 1 to dw_sn_change_for_soc_child.RowCount()
			dw_sn_change_for_soc_child.SetItem(li_Row_count, "Serial_No_Child",dw_sn_change_for_soc_child.GetItemString( li_Row_count,"CurrentSerialNumber"))
		Next
	
	End If

	If dw_sn_change_for_delivery_order_child.RowCount() > 0 Then
	
		For  li_Row_count = 1 to dw_sn_change_for_delivery_order_child.RowCount()
			dw_sn_change_for_delivery_order_child.SetItem(li_Row_count, "Serial_No",dw_sn_change_for_delivery_order_child.GetItemString( li_Row_count,"CurrentSerialNumber"))
			Next
	
	End If

	cb_update.enabled 					= FALSE
	cb_validate.Enabled 	   				= TRUE
	sle_new_serial_number.Enabled 	=TRUE

	sle_new_serial_number.SelectText(1 , Len(TRIM(sle_new_serial_number.Text )))
	sle_new_serial_number.SetFocus()

Else	
	
	If cb_validate.enabled 	= TRUE Then
		
		sle_new_serial_number.SelectText(1 , Len(TRIM(sle_new_serial_number.Text )))	
		sle_new_serial_number.SetFocus()
		
	Else
		
		If cb_search.enabled 	= TRUE Then
			
			sle_current_serial_number.SelectText(1 , Len(TRIM(sle_current_serial_number.Text )))	
			sle_current_serial_number.SetFocus()
			
		End If
		
	End If
		
End If
end event

type dw_sn_change_for_receive_order_child from u_dw_ancestor within w_sn_change
integer x = 32
integer y = 704
integer width = 4535
integer height = 772
integer taborder = 50
boolean titlebar = true
string title = "Received Orders with this Serial Number"
string dataobject = "d_sn_change_for_receive_order_child"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event clicked;String ls_OldSerialNumber, ls_NewSerialNumber

If row > 0 and cb_validate.Enabled  = FALSE Then
	
	 ls_OldSerialNumber		=	dw_sn_change_for_receive_order_child.GetItemString( row, "CurrentSerialNumber")
	 ls_NewSerialNumber		=	dw_sn_change_for_receive_order_child.GetItemString( row, "Serial_No")	

	If ls_OldSerialNumber	 = ls_NewSerialNumber Then
		dw_sn_change_for_receive_order_child.SetItem( row, "Serial_No", sle_new_serial_number.text )
		cb_update.enabled   = TRUE
	Else
		dw_sn_change_for_receive_order_child.SetItem( row, "Serial_No", dw_sn_change_for_receive_order_child.GetItemString( row, "CurrentSerialNumber"))	
	End If

End If

end event

type dw_search from datawindow within w_sn_change
boolean visible = false
integer x = 96
integer y = 956
integer width = 4087
integer height = 180
integer taborder = 10
boolean enabled = false
string dataobject = "d_adjust_search"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string ls_supp_code,ls_sku
string ls_null
Setnull(ls_null)
Long ll_rtn

Choose Case dwo.name

case 'sku'
	//Check if item_master has the records for entered sku	
	ll_rtn=i_nwarehouse.of_item_sku(gs_project,data)
	IF ll_rtn > 0 THEN	
		//Check in drop down datawindows & insert row just to escape from retrieve
//		IF idwc_supplier.Retrieve(gs_project,data) > 0 THEN
//			ls_supp_code =idwc_supplier.Getitemstring(1,"supp_code")		
//		END IF
		//Check if ddw is 0 then insert to avoid retrival argument pop up
		//IF ddw ret 1 row then assign the value to dupp_code
   	IF ll_rtn = 1   THEN	
				ls_supp_code=i_nwarehouse.ids_sku.object.supp_code[row] 
			  	This.object.supp_code[ row ] = ls_supp_code
				ls_sku = data
				IF ll_rtn = 1 THEN Post f_setfocus(dw_search,row,'wh_code')
		ELSEIF ll_rtn > 1 THEN
				this.object.supp_code[row] = ls_null
				f_setfocus(dw_search,row,'supp_code')	
   	END IF
 Else			
		MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
		Post f_setfocus(dw_search,row,'sku')
		return 2
 END IF

Case 'supp_code'
	 ls_sku = this.Getitemstring(row,"sku")
	 ls_supp_code = data
	 
END Choose			
Return


end event

event constructor;i_nwarehouse = Create n_warehouse
//this.Getchild("supp_code",idwc_supplier)
//idwc_supplier.SettransObject(SQLCA)
//idwc_supplier.InsertRow(0)
ib_start_from_first 		= TRUE
ib_start_to_first 		= TRUE
g.of_check_label(this) 
end event

event destructor;Destroy i_nwarehouse
end event

event clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_search.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_search.GetRow()

CHOOSE CASE ls_column
		
	CASE "s_date"
		
		IF ib_start_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_search.SetColumn("s_date")
			dw_search.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_start_from_first = FALSE
			
		END IF
		
	CASE "e_date"
		
		IF ib_start_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_search.SetColumn("e_date")
			dw_search.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_start_to_first = FALSE
			
		END IF
		
			
	CASE ELSE
		
END CHOOSE

end event

type r_1 from rectangle within w_sn_change
integer linethickness = 8
long fillcolor = 16777215
integer x = 32
integer y = 216
integer width = 4539
integer height = 456
end type

type r_2 from rectangle within w_sn_change
boolean visible = false
integer linethickness = 9
long fillcolor = 16777215
integer x = 32
integer y = 628
integer width = 2194
integer height = 144
end type

type r_3 from rectangle within w_sn_change
integer linethickness = 8
long fillcolor = 16777215
integer x = 37
integer y = 20
integer width = 407
integer height = 148
end type

type r_4 from rectangle within w_sn_change
boolean visible = false
integer linethickness = 9
long fillcolor = 16777215
integer x = 32
integer y = 1448
integer width = 1303
integer height = 144
end type

type r_5 from rectangle within w_sn_change
boolean visible = false
integer linethickness = 9
long fillcolor = 16777215
integer x = 32
integer y = 2268
integer width = 1303
integer height = 144
end type

type dw_sn_change_for_delivery_order_child from u_dw_ancestor within w_sn_change
integer x = 32
integer y = 2280
integer width = 4535
integer height = 772
integer taborder = 80
boolean titlebar = true
string title = "Delivery Orders with this Serial Number"
string dataobject = "d_sn_change_for_delivery_order_child"
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event clicked;String ls_OldSerialNumber, ls_NewSerialNumber

If row > 0 and cb_validate.Enabled  = FALSE Then
	
	 ls_OldSerialNumber		=	dw_sn_change_for_delivery_order_child.GetItemString( row, "CurrentSerialNumber")
	 ls_NewSerialNumber		=	dw_sn_change_for_delivery_order_child.GetItemString( row, "Serial_No")	

	If ls_OldSerialNumber	 = ls_NewSerialNumber Then
		dw_sn_change_for_delivery_order_child.SetItem( row, "Serial_No", sle_new_serial_number.text )
		cb_update.enabled   = TRUE
	Else
		dw_sn_change_for_delivery_order_child.SetItem( row, "Serial_No", dw_sn_change_for_delivery_order_child.GetItemString( row, "CurrentSerialNumber"))	
	End If

End If

end event

