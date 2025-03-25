$PBExportHeader$sims3fp.sra
$PBExportComments$SIMS FIle Processing application
forward
global type sims3fp from application
end type
global sims_transaction sqlca
global transaction om_sqlca //30-MAY-2017 :Madhu -PINT -OM Transaction Object
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
Integer	giLogFileNo,	&
			giErrorFileNo
String	gsCommandParm,	&
			gsErrorFileName,	&
			gsEnvironment,		&
			gsIniFile, gsEmail,gsFileName

u_nvo_process_files	gu_nvo_process_files

Boolean	gbHalt, gbReady

mailSession gmMailSession
mailReturnCode gmMailRet

//TimA 01/24/12 OTM Project
//Global flag to run OTM
String gs_OTM_Flag, gsOTMSendInboundOrder, gsOTMSendOutboundOrder

//TimA 06/06/12
//Global flag to turn on or off method log tracing
String gs_method_log_flag

String gsDoNo,gsRoNo //29-Sep-2014 :Madhu -KLN B2B Conversion to SPS

String gsEmailSubject //2019/05/31  - S33973  - Added a global email subjuct line to allow customization within a process

end variables
global type sims3fp from application
string appname = "sims3fp"
end type
global sims3fp sims3fp

type variables

end variables

on sims3fp.create
appname="sims3fp"
message=create message
sqlca=create sims_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
//om_sqlca = create transaction
end on

on sims3fp.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
destroy(om_sqlca)
end on

event open;
//Open Log File
//giLogFileNo = FileOPen('simsfp.log',LineMode!,Write!,Shared!)

gsCommandParm = commandline

gu_nvo_process_files = Create u_nvo_process_files

//Process files based on input parm
gu_nvo_process_files.uf_open()


end event

event close;
gu_nvo_process_files.uf_close()
end event

event systemerror;String	lsOutput

lsOutput = String(Today(), "mm/dd/yyyy hh:mm") + ' - SIMSFP.EXE System Error: ' + error.text + ', Event: ' + error.objectEvent + ', Line: ' + string(error.line)
FileWrite(giLogFileNo,lsOutput)

gu_nvo_process_files.uf_send_email('XX','System','***SIMSFP - System Error***',lsOutput,'') /*send an email mesg to the systems distribution list*/
end event

