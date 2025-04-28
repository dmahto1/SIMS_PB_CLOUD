$PBExportHeader$u_dw.sru
forward
global type u_dw from u_dw_ancestor
end type
end forward

global type u_dw from u_dw_ancestor
integer height = 360
end type
global u_dw u_dw

type variables
private string is_selection_mode = "n"
private n_cst_dw_row_helper idw_row_helper
private u_dw_microhelp io_microhelp
private boolean ib_microhelp_registered = FALSE

end variables

forward prototypes
public subroutine of_register (singlelineedit ao_microhelp)
end prototypes

public subroutine of_register (singlelineedit ao_microhelp);// u_dw.of_register
// ARGUMENTS        u_dw_microhelp
// RETURN VALUE (None)
// DESCRIPTION      Registers the microhelp to the datawindow
io_microhelp = ao_microhelp
io_microhelp.of_register(this)
ib_microhelp_registered = TRUE
end subroutine

on u_dw.create
call super::create
end on

on u_dw.destroy
call super::destroy
end on

event itemfocuschanged;call super::itemfocuschanged;/// u_dw.ItemFocusChanged
// ARGUMENTS Long row, dwo the column
// RETURN VALUE (None)
// DESCRIPTION
// If there is a tag property set for the dwo and if the microhelp is instantiated
// I display that tag
IF not ib_microhelp_registered then return
io_microhelp.text = dwo.tag

end event

