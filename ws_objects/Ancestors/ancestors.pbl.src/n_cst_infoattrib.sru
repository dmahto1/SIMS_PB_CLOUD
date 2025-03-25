$PBExportHeader$n_cst_infoattrib.sru
forward
global type n_cst_infoattrib from n_base
end type
end forward

global type n_cst_infoattrib from n_base autoinstantiate
end type

type variables
Public:

string	is_name
string	is_description

end variables

on n_cst_infoattrib.create
TriggerEvent( this, "constructor" )
end on

on n_cst_infoattrib.destroy
TriggerEvent( this, "destructor" )
end on

