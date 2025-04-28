$PBExportHeader$w_log.srw
$PBExportComments$Log window which allows SIMS users to view logging information to/from SIMS and external systems.  Currently OTM logging is implemented.
forward
global type w_log from window
end type
end forward

global type w_log from window
integer width = 4050
integer height = 2404
boolean titlebar = true
string title = "SIMS Logging"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
end type
global w_log w_log

on w_log.create
end on

on w_log.destroy
end on

event resize;if IsValid(u_otm_log) then
	u_otm_log.of_resize(newwidth, newheight)
end if
end event

event open;// LTK 20120221	Logging window can be used in the future for logging other than OTM.  Encapsulated the OTM logic in a user object.

OpenUserObjectWithParm(u_otm_log, this, 20, 20)

end event

