$PBExportHeader$n_cst_dwobjectattrib.sru
forward
global type n_cst_dwobjectattrib from n_base
end type
end forward

global type n_cst_dwobjectattrib from n_base autoinstantiate
end type

type variables
Public:
string 	is_column
string	is_datatype
string 	is_value
end variables

on n_cst_dwobjectattrib.create
TriggerEvent( this, "constructor" )
end on

on n_cst_dwobjectattrib.destroy
TriggerEvent( this, "destructor" )
end on

