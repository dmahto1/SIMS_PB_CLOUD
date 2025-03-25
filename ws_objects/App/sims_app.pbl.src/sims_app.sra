$PBExportHeader$sims_app.sra
$PBExportComments$Generated Application Object
forward
global type sims_app from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type sims_app from application
string appname = "sims_app"
end type
global sims_app sims_app

on sims_app.create
appname = "sims_app"
message = create message
sqlca = create transaction
sqlda = create dynamicdescriptionarea
sqlsa = create dynamicstagingarea
error = create error
end on

on sims_app.destroy
destroy( sqlca )
destroy( sqlda )
destroy( sqlsa )
destroy( error )
destroy( message )
end on

