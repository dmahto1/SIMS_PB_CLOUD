HA$PBExportHeader$w_maintenance_esd_configuration.srw
$PBExportComments$SIMSPEVS-537 PAN Advance ESD configuration
forward
global type w_maintenance_esd_configuration from w_std_simple_list
end type
end forward

global type w_maintenance_esd_configuration from w_std_simple_list
integer width = 4699
integer height = 1664
string title = "Delivery Advance ESD Configuration"
end type
global w_maintenance_esd_configuration w_maintenance_esd_configuration

type variables
int iiWidth
int iiHeight

end variables

forward prototypes
public function integer getwidth ()
public subroutine setheight (integer _height)
public subroutine setwidth (integer _width)
public function integer getheight ()
end prototypes

public function integer getwidth ();// getwidth
return iiWidth

end function

public subroutine setheight (integer _height);// setHeight( int _height )
iiheight = _height

end subroutine

public subroutine setwidth (integer _width);// setHeight( int _height )

iiwidth = _width

end subroutine

public function integer getheight ();// int = getHeight()
return iiHeight
end function

on w_maintenance_esd_configuration.create
call super::create
end on

on w_maintenance_esd_configuration.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_preopen;call super::ue_preopen;
dw_list.SetTransObject(sqlca)
This.triggerEvent('ue_retrieve')

end event

event resize;call super::resize;//Gailm 10/2017
setwidth( newwidth )
setheight( newheight )
dw_list.event ue_resize()
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_esd_configuration
integer x = 9
integer y = 0
integer width = 4608
integer height = 1448
string dataobject = "d_delivery_advance_esd_configuration"
boolean hscrollbar = true
boolean resizable = true
end type

event dw_list::ue_resize;call super::ue_resize;this.width = ( parent.getwidth() - 50 )
this.height = ( parent.getheight() - 50 )
this.x = 18

end event

