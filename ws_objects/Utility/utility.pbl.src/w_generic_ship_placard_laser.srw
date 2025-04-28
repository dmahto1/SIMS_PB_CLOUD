$PBExportHeader$w_generic_ship_placard_laser.srw
$PBExportComments$Print a generic 8 x 11 Shipping placard on a laser printer
forward
global type w_generic_ship_placard_laser from w_std_report
end type
end forward

global type w_generic_ship_placard_laser from w_std_report
integer x = 567
integer y = 564
integer width = 3717
integer height = 2420
string title = "Shipping Label"
end type
global w_generic_ship_placard_laser w_generic_ship_placard_laser

type variables
String	isDONO

end variables

on w_generic_ship_placard_laser.create
call super::create
end on

on w_generic_ship_placard_laser.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;

If isDONO > '' Then
	SetPointer(HourGlass!)
	dw_report.Retrieve(isDoNO)
	SetPointer(Arrow!)
	im_menu.m_file.m_print.Enabled = True
End If
end event

event open;//Ancestor being overridden

// Intitialize
This.X = 0
This.Y = 0


is_title = This.Title
im_menu = This.MenuId
dw_report.SetTransObject(sqlca)

This.PostEvent("ue_postopen") /* 06/00 PCONKL*/


end event

event ue_clear;dw_select.Reset()
dw_select.Insertrow(0)
end event

event ue_postopen;call super::ue_postopen;
If isvalid(w_do) Then
	
	isDONO = w_do.idw_Main.GetITemSTring(1,'do_no')
	TriggerEvent('ue_retrieve')
Else
	
	Messagebox("Ship Labels","You must have a valid Delivery Order open to print Shipping Labels!")
	TriggerEvent('ue_Clode')
	
End If
end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 50,workspaceHeight()-75)
end event

type dw_select from w_std_report`dw_select within w_generic_ship_placard_laser
boolean visible = false
integer x = 0
integer y = 16
integer width = 1929
integer height = 160
string dataobject = "d_ship_label-select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_generic_ship_placard_laser
integer x = 2350
integer y = 12
integer width = 270
integer height = 100
integer taborder = 20
end type

event cb_clear::clicked;call super::clicked;
dw_select.reset()
dw_select.insertrow(0)

end event

type dw_report from w_std_report`dw_report within w_generic_ship_placard_laser
integer x = 50
integer y = 68
integer width = 3511
integer height = 2108
integer taborder = 30
string dataobject = "d_generic_ship_placard_laser"
boolean hscrollbar = true
end type

