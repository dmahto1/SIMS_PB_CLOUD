$PBExportHeader$replication_transaction.sru
$PBExportComments$Transaction object for Replicated server
forward
global type replication_transaction from transaction
end type
end forward

global type replication_transaction from transaction
end type
global replication_transaction replication_transaction

on replication_transaction.create
call super::create
TriggerEvent( this, "constructor" )
end on

on replication_transaction.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

