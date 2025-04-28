$PBExportHeader$n_cst_propertyattrib.sru
forward
global type n_cst_propertyattrib from n_base
end type
end forward

global type n_cst_propertyattrib from n_base autoinstantiate
end type

type variables
Public:

// Note:  Not all attributes will be used by all objects.
string	is_name
string	is_description
string	is_propertypage[]
string	is_propertytabtext
boolean	ib_switchbuttons
end variables

on n_cst_propertyattrib.create
TriggerEvent( this, "constructor" )
end on

on n_cst_propertyattrib.destroy
TriggerEvent( this, "destructor" )
end on

