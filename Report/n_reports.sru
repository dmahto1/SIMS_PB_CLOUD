HA$PBExportHeader$n_reports.sru
forward
global type n_reports from nonvisualobject
end type
end forward

global type n_reports from nonvisualobject
end type
global n_reports n_reports

on n_reports.create
TriggerEvent( this, "constructor" )
end on

on n_reports.destroy
TriggerEvent( this, "destructor" )
end on

