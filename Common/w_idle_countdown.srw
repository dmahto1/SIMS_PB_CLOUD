HA$PBExportHeader$w_idle_countdown.srw
forward
global type w_idle_countdown from w_response_ancestor
end type
type st_timer from statictext within w_idle_countdown
end type
type st_1 from statictext within w_idle_countdown
end type
type st_2 from statictext within w_idle_countdown
end type
type st_3 from statictext within w_idle_countdown
end type
end forward

global type w_idle_countdown from w_response_ancestor
integer width = 2597
integer height = 480
string title = "Application Idle Countdown"
st_timer st_timer
st_1 st_1
st_2 st_2
st_3 st_3
end type
global w_idle_countdown w_idle_countdown

type variables
time countdown

end variables

forward prototypes
public subroutine settimedisplay (time _newtime)
public subroutine setcountdown (time _countdown)
public function time getcountdown ()
end prototypes

public subroutine settimedisplay (time _newtime);// setTimeDisplay( time _newtime )

string sminute
string sSecond


sminute = String(  minute( _newtime ) )
sSecond = String ( second( _newTime ) )


st_timer.Text = "This Instance of SIMS will Terminate in: " + sminute + " minutes and " + sSecond + " seconds."



end subroutine

public subroutine setcountdown (time _countdown);// setCountDown( time _countdown )
countdown = _countdown

end subroutine

public function time getcountdown ();// time = getCountDown()
return countdown

end function

on w_idle_countdown.create
int iCurrent
call super::create
this.st_timer=create st_timer
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_timer
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
end on

on w_idle_countdown.destroy
call super::destroy
destroy(this.st_timer)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
end on

event open;call super::open;setTimeDisplay( now() )
setCountdown( Time( "00:" + String( g.getProjectAppTeminateTime() ) + ":00" ) )
timer( 1)

end event

event timer;call super::timer;DateTIme	ldtLogout

// time

time _countdown

_countdown = getCountDown()
SetCountdown( RelativeTime(_countdown,  - 1) )
if minute( getCountDown() ) <= 0 then 
	if second( getCountDown() ) <= 0 then
	
		//06/17/11 - cawikholm - Update USer Login history with logout time
		
		If gs_userid > '' Then
			
			ldtLogout = DateTime(today(),Now())
		
			Execute Immediate "Begin Transaction" using SQLCA;
		
			Update User_login_history
			Set logout_time = :ldtLogout
			Where Project_id = :gs_Project and UserID = :gs_userid and login_time = :g.idt_USer_Login_Time
			Using SQLCA;
			
			Execute Immediate "COMMIT" using SQLCA;
			
		End If
		
		Execute Immediate "COMMIT" using SQLCA; /* 06/17 - If we have an unmatched Begin Trans, this should commit any hanging updates*/
		
		Disconnect;
		
		halt close
	end if
end if
setTimeDisplay( getCountDown() )

end event

event mousemove;call super::mousemove;close( this )

end event

event key;call super::key;close( this )

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_idle_countdown
boolean visible = false
integer x = 1600
integer y = 948
end type

type cb_ok from w_response_ancestor`cb_ok within w_idle_countdown
boolean visible = false
integer x = 1605
integer y = 948
end type

type st_timer from statictext within w_idle_countdown
integer x = 14
integer y = 96
integer width = 2569
integer height = 116
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_idle_countdown
integer x = 5
integer width = 2569
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SIMS Has Remained IDLE For Too Long!"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_idle_countdown
integer x = 5
integer y = 224
integer width = 2569
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Move The Mouse Over This Message"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_idle_countdown
integer x = 5
integer y = 316
integer width = 2569
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Or Press Any Key To Resume"
alignment alignment = center!
boolean focusrectangle = false
end type

