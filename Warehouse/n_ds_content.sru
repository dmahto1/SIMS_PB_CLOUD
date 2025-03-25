HA$PBExportHeader$n_ds_content.sru
$PBExportComments$-
forward
global type n_ds_content from datastore
end type
end forward

global type n_ds_content from datastore
end type
global n_ds_content n_ds_content

type variables

String	isErrorText
end variables

forward prototypes
public function string wf_get_db_error_text ()
end prototypes

public function string wf_get_db_error_text ();
Return iserrortext
end function

on n_ds_content.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_ds_content.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event retrievestart;return 2
end event

event dberror;
isErrorText = sqlerrtext
end event

