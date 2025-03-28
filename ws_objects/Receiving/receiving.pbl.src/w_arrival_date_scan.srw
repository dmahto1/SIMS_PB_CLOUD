$PBExportHeader$w_arrival_date_scan.srw
forward
global type w_arrival_date_scan from window
end type
type st_1 from statictext within w_arrival_date_scan
end type
type cb_1 from commandbutton within w_arrival_date_scan
end type
type dw_1 from datawindow within w_arrival_date_scan
end type
end forward

global type w_arrival_date_scan from window
integer width = 2117
integer height = 692
boolean titlebar = true
string title = "SIMS"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_1 cb_1
dw_1 dw_1
end type
global w_arrival_date_scan w_arrival_date_scan

type variables
Boolean ibkeytype =FALSE	
long ll_wait_time
end variables

on w_arrival_date_scan.create
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.st_1,&
this.cb_1,&
this.dw_1}
end on

on w_arrival_date_scan.destroy
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;dw_1.insertrow(0)



end event

event closequery;
str_parms	lstrparms


lstrparms.string_arg[1] = dw_1.getitemstring(1,'arrival_date')
 Message.PowerObjectParm= lstrparms 
 



end event

event timer;

//ibkeytype=FALSE
//timer(0)
//cb_1.triggerevent('clicked')
 

	


end event

type st_1 from statictext within w_arrival_date_scan
integer x = 73
integer y = 96
integer width = 475
integer height = 96
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Arrival Date"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_arrival_date_scan
boolean visible = false
integer x = 878
integer y = 288
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ok"
end type

event clicked;//SIMS-55 Added by Dhirendra -Start
dw_1.AcceptText()
IF  isdate(string(date(dw_1.getitemstring(1,'arrival_date')))) and string(date(dw_1.getitemstring(1,'arrival_date'))) <> '1/1/1900' THEN
   CLOSE(PARENT)
ELSEIF string(date(dw_1.getitemstring(1,'arrival_date'))) = '1/1/1900'  then	
	MessageBox("Alert","Date format is not correct~r~nPlease type/scan the correct Date format ")	
	dw_1.setitem(1,'arrival_date','')
else
	MessageBox("Manual Entry","Doesn't Accept Manual Entry")
      dw_1.setitem(1,'arrival_date','')
END IF  
//SIMS-55 Added by Dhirendra -END
end event

type dw_1 from datawindow within w_arrival_date_scan
event ue_copypaste_restrict pbm_dwnkey
event process_enter pbm_dwnprocessenter
integer x = 585
integer y = 96
integer width = 1061
integer height = 128
integer taborder = 10
string title = "none"
string dataobject = "d_arrival_date_scan"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_copypaste_restrict;////******** Created event by Dhirendra to restrict manuual entry and copy/paste for arrival date field*********//
//
boolean ib_CaptureTab = true
string ls_columnname
decimal ld_wait_time
ls_columnname =this.getcolumnname()
	cb_1.visible = true

IF trim(ls_Columnname) <> "" THEN // 86 Is the ANSCII value for V
IF  KeyDown(Keycontrol!) and KeyDown(86) and (ls_columnname ='arrival_date') THEN
	string ls_1 = ''
	ls_1 = clipboard()
	ls_1 =""
	::clipboard(ls_1) 
	MessageBOx("Info","You can't use copy/paste to this field")
END IF 
END IF




end event

event process_enter;cb_1.triggerevent('clicked')
end event

