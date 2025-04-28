HA$PBExportHeader$u_ds_ancestor.sru
forward
global type u_ds_ancestor from datastore
end type
end forward

global type u_ds_ancestor from datastore
end type
global u_ds_ancestor u_ds_ancestor

type variables

String	isDBErrTExt
end variables

forward prototypes
public function String wf_get_error_text ()
end prototypes

public function String wf_get_error_text ();
REturn isdberrtext
end function

on u_ds_ancestor.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_ds_ancestor.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;
isdberrtext = sqlerrtext
end event

