HA$PBExportHeader$u_ds.sru
$PBExportComments$-
forward
global type u_ds from datastore
end type
end forward

global type u_ds from datastore
end type
global u_ds u_ds

on u_ds.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on u_ds.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

