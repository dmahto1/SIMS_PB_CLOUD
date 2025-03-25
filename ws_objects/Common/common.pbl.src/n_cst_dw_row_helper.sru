$PBExportHeader$n_cst_dw_row_helper.sru
forward
global type n_cst_dw_row_helper from nonvisualobject
end type
end forward

global type n_cst_dw_row_helper from nonvisualobject
end type
global n_cst_dw_row_helper n_cst_dw_row_helper

on n_cst_dw_row_helper.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_dw_row_helper.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

