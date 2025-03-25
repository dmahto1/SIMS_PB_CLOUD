$PBExportHeader$sqlcz.sru
forward
global type sqlcz from transaction
end type
end forward

global type sqlcz from transaction
end type
global sqlcz sqlcz

on sqlcz.create
call super::create
TriggerEvent( this, "constructor" )
end on

on sqlcz.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;// Profile OldDiskErase
DBMS = "ODBC"
AutoCommit = False
DBParm = "ConnectString='DSN=OldDiskErase'"

end event

