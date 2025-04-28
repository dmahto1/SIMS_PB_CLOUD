HA$PBExportHeader$w_master.srw
$PBExportComments$Standard obejct for master detail windows
forward
global type w_master from window
end type
end forward

global type w_master from window
integer width = 2533
integer height = 1408
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_preopen ( )
event ue_postopen ( )
event type integer ue_preclose ( )
event ue_postclose ( )
event type long ue_save ( )
event type integer ue_preupdate ( )
event ue_postupdate ( )
end type
global w_master w_master

forward prototypes
public function integer of_save ()
end prototypes

event ue_save;IF This.Event ue_preupdate() = -1 THEN Return -1
This.Post Event ue_postupdate()
Return 0
end event

public function integer of_save ();Integer li_rtn
li_rtn = 1
IF Event ue_save() = -1 THEN li_rtn = -1
Return li_rtn
end function

on w_master.create
end on

on w_master.destroy
end on

event open;This.Event ue_Preopen()
This.Post Event ue_postopen() 
end event

event close;Event ue_preclose() 
Post Event ue_postclose()
end event

