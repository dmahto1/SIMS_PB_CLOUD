$PBExportHeader$u_dw_microhelp.sru
$PBExportComments$A microhelp object to register to the datawindow
forward
global type u_dw_microhelp from singlelineedit
end type
end forward

global type u_dw_microhelp from singlelineedit
integer width = 413
integer height = 118
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
string text = "none"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type
global u_dw_microhelp u_dw_microhelp

type variables
 u_dw u_dw_microhelp

end variables

forward prototypes
public subroutine of_register (datawindow adw)
end prototypes

public subroutine of_register (datawindow adw);// ARGUMENTS u_dw
// RETURN VALUE (None)
// DESCRIPTION
// Registers the datawindow with this object
u_dw = adw
end subroutine

on u_dw_microhelp.create
end on

on u_dw_microhelp.destroy
end on

