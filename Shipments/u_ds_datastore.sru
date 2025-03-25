HA$PBExportHeader$u_ds_datastore.sru
$PBExportComments$Generic datastore with db error code
forward
global type u_ds_datastore from datastore
end type
end forward

global type u_ds_datastore from datastore
end type
global u_ds_datastore u_ds_datastore

on u_ds_datastore.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_ds_datastore.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;//String	lsLogout

//lsLogOut = Space(17) + "- ***System Error!  Unable to Save records to database (" + sqlerrtext + ")!"
//FileWrite(gilogFileNo,lsLogOut)

//For Client version...
messagebox("System Error!", sqlerrtext)
end event

event error;
action = exceptionIgnore!
end event

