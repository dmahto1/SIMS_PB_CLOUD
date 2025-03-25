HA$PBExportHeader$w_unallocate_location.srw
$PBExportComments$Un-allocate to Location.
forward
global type w_unallocate_location from window
end type
type cb_ok from commandbutton within w_unallocate_location
end type
type st_1 from statictext within w_unallocate_location
end type
type st_loc from statictext within w_unallocate_location
end type
type sle_loc from singlelineedit within w_unallocate_location
end type
end forward

global type w_unallocate_location from window
integer width = 1518
integer height = 744
boolean titlebar = true
string title = "Return to Stock"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_ok cb_ok
st_1 st_1
st_loc st_loc
sle_loc sle_loc
end type
global w_unallocate_location w_unallocate_location

type variables
str_parms	is_strparm
end variables
on w_unallocate_location.create
this.cb_ok=create cb_ok
this.st_1=create st_1
this.st_loc=create st_loc
this.sle_loc=create sle_loc
this.Control[]={this.cb_ok,&
this.st_1,&
this.st_loc,&
this.sle_loc}
end on

on w_unallocate_location.destroy
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.st_loc)
destroy(this.sle_loc)
end on

event close;//26-SEP-2017 :Madhu PEVS-848 - KDO - Return to Stock

If (is_strparm.string_arg[4] <> 'OK') Then
	is_strparm.string_arg[4] ='Close' //close event
End If

Message.powerobjectparm = is_strparm

end event

event open;is_strparm = Message.powerobjectparm
end event

type cb_ok from commandbutton within w_unallocate_location
integer x = 485
integer y = 452
integer width = 475
integer height = 132
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;//26-SEP-2017 :Madhu PEVS-848 - KDO - Return to Stock
//validate Location.
String ls_loc, ls_wh
long ll_count, llRow

ls_loc = sle_loc.text

//get warehouse
ls_wh = is_strparm.string_arg[3] //warehouse

//validate location exists or not
SELECT  count(*) into :ll_count
FROM Location with(nolock)
WHERE Wh_Code =:ls_wh and L_code =:ls_loc
USING SQLCA;

IF ll_count > 0 Then
	
	//update location to all pick records.
	For llRow =1 to w_do.idw_pick.rowcount()
		w_do.idw_pick.setItem(llRow, 'l_code',ls_loc)
	Next
	
else
	MessageBox('Return to Stock', "Location# "+ls_loc+" does not exist, please provide a valid location! ")
	Return
End IF

is_strparm.string_arg[4] ='OK'
Message.powerobjectparm = is_strparm

close(parent)
end event

type st_1 from statictext within w_unallocate_location
integer x = 27
integer y = 52
integer width = 1326
integer height = 104
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217857
long backcolor = 67108864
string text = "Un-allocate to Location..."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_loc from statictext within w_unallocate_location
integer x = 50
integer y = 248
integer width = 389
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Location:"
boolean focusrectangle = false
end type

type sle_loc from singlelineedit within w_unallocate_location
integer x = 430
integer y = 236
integer width = 782
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

