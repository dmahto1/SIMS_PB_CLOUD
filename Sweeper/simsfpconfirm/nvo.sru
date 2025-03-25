HA$PBExportHeader$nvo.sru
forward
global type nvo from nonvisualobject
end type
end forward

global type nvo from nonvisualobject
end type
global nvo nvo

on nvo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

