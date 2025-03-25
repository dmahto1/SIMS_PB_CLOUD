HA$PBExportHeader$w_main.srw
$PBExportComments$SIMS File Processing main window
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
type cb_go from commandbutton within w_main
end type
type st_4 from statictext within w_main
end type
type st_3 from statictext within w_main
end type
type st_2 from statictext within w_main
end type
type st_1 from statictext within w_main
end type
type sle_sweep_interval from singlelineedit within w_main
end type
type dw_log from datawindow within w_main
end type
type cb_pause from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 2866
integer height = 2024
boolean titlebar = true
string title = "SIMS Electronic File Processing - V20100510"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
long backcolor = 67108864
event ue_print ( )
event ue_clear ( )
event ue_change_log ( )
mdi_1 mdi_1
cb_go cb_go
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
sle_sweep_interval sle_sweep_interval
dw_log dw_log
cb_pause cb_pause
end type
global w_main w_main

type variables
Protected long il_interval // KZUV.COM - Length of sweeper cycle in seconds.
Protected long il_remaining // KZUV.COM - Time remaining in this sweeper cycle.
Protected boolean ib_paused // KZUV.COM - True if timer is 'paused'.
end variables

forward prototypes
public function boolean f_settimer (long al_interval)
public function boolean f_pause ()
end prototypes

event ue_print;
Openwithparm(w_dw_print_options,dw_log) 
end event

event ue_clear;
dw_log.Reset()
end event

event ue_change_log;
gu_nvo_process_files.uf_change_log()
end event

public function boolean f_settimer (long al_interval);// Designed by KZUV.COM

// Store the timer interval
il_interval = al_interval

// Store the time remaining.
il_remaining = al_interval

// Log the change.
FileWrite(gilogFileNo, 'Sweep Delay modified to (seconds): ' + String(Long(sle_sweep_interval.Text)))

// Start the timer.
timer(1)

// Show the time remaining.
cb_pause.text = string(al_interval)

// Return true.
return true	
end function

public function boolean f_pause ();// Original design by KZUV.COM

string ls_logstring

// IF the timer is paused,
If ib_paused then
	
	// Unpause the timer.
	ib_paused = false
	
	// Reset the button text to the remaining time.
	cb_pause.text = string(il_remaining)
	
	// Set the log string.
	ls_logstring = '               - Sweeper UnPaused. - '
	
	// Restart the sweeper for 1 second.
	timer(1)
	
// Otherwise, if the timer is running,
Else
	
	// Unpause the timer.
	ib_paused = true
	
	// Reset the button text to 'PAUSED'.
	cb_pause.text = ">"
	
	// Stop the timer.
	timer(0)
	
	// Set the log string.
	ls_logstring = '               - Sweeper Paused. - '
	
// End if the timer is running.
End If

// Add the date and time to logstring.
ls_logstring += String(Today(), "mm/dd/yyyy hh:mm:ss")

// Update the logfile and console.
FileWrite(giLogFileNo,ls_logstring)
gu_nvo_process_files.uf_write_log(ls_logstring)

// Return true
return true
end function

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.cb_go=create cb_go
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_sweep_interval=create sle_sweep_interval
this.dw_log=create dw_log
this.cb_pause=create cb_pause
this.Control[]={this.mdi_1,&
this.cb_go,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.sle_sweep_interval,&
this.dw_log,&
this.cb_pause}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
destroy(this.cb_go)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_sweep_interval)
destroy(this.dw_log)
destroy(this.cb_pause)
end on

event open;Integer			li_ScreenH, li_ScreenW
Environment	le_Env

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2
end event

event timer;// If the remaining time is greater than 0,
If il_remaining > 0 then
	
	// Decrement the time remaining.
	il_remaining --
	
	// Update the time remaining field.
	cb_pause.text = string(il_remaining)
	
	// Restart the sweeper for 1 second.
	timer(1)
	
// Otherwise, if the timer has run out,
Else
	
	// If the last sweeper cycle has completed,
	If gbReady Then
		
		// Disable the timer while were processing files.
		timer(0)
		
		// Disable the pause button while processing files.
		cb_pause.enabled = false
		cb_go.enabled = false
		
		// Kick off the sweeper processing cycle.
		
		// LTK 20111117	Project blocking sweeper change.  The file driver will return a 1 if not all transactions were processed 
		//						and the sweeper will then be refired.
		//
		//gu_nvo_process_files.uf_main_file_driver()		
		
		// Reset il_remaining
		//il_remaining = il_interval

		if gu_nvo_process_files.uf_main_file_driver() = 1 then
			// More transactions are queued, refire the sweeper
			il_remaining = 0
		else
			// Reset il_remaining
			il_remaining = il_interval
		end if
		// LTK 20111117	End of project blocking sweeper change.
	
		// Re-Enable the pause button.
		cb_pause.enabled = true
		cb_go.enabled=true
		
		// Re-enable the timer.
		timer(1)
	End If
	
// End if the timer has run out.
End IF

// Pause the processing to give the user a chance to cancel.
Yield()

// IF the user wants to cancel,
If gbhalt Then
	
	// Quit processing and close the sweeper.
	gu_nvo_process_files.uf_close()
End If
end event

event closequery;
Timer(0)

//App will check for this variable and cancel after next sweep - if not sweeping, we can close now
If gbReady Then
	gu_nvo_process_files.uf_close()
Else
	gbHalt = True /*will halt after next run*/
End If

Return 1
end event

event resize;dw_log.Resize(workspacewidth() - 40,workspaceHeight()-270)
end event

type mdi_1 from mdiclient within w_main
long BackColor=268435456
end type

type cb_go from commandbutton within w_main
integer x = 850
integer y = 164
integer width = 366
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "GO"
boolean default = true
end type

event clicked;cb_pause.text = string(0)
il_remaining = 0
this.enabled = false
end event

type st_4 from statictext within w_main
integer x = 1957
integer y = 128
integer width = 471
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Next Sweep"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_main
integer x = 1957
integer y = 192
integer width = 471
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "(in Seconds)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_main
integer y = 196
integer width = 471
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "(in Seconds)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_main
integer x = 5
integer y = 136
integer width = 471
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sweep Interval:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_sweep_interval from singlelineedit within w_main
integer x = 489
integer y = 160
integer width = 343
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;String	lsOutput

// If the value entered is numeric,
If isnumber(this.Text) Then
	
	// Unpause if necessary.
	ib_paused = false
	
	// Set the timer.
	f_settimer(Long(this.Text))
	lsOutput = 'Sweep Delay modified to (seconds): ' + String(Long(this.Text))
	
// Otherwise, if the value entered is NOT numeric,
Else
	
	// Show error to the user.
	Messagebox('','Sweep interval must be numeric')
	
	// Set the interval to 300 seconds.
	f_settimer(300)
	
// End if the value entered is NOT numeric.
End If

// Send status to the log file and update the console.
FileWrite(gilogFileNo,lsOutput)
gu_nvo_process_files.uf_write_Log(lsOutput)
end event

type dw_log from datawindow within w_main
integer x = 5
integer y = 264
integer width = 2784
integer height = 1556
integer taborder = 10
string title = "none"
string dataobject = "d_log"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;SetRowFocusIndicator(hand!)
end event

type cb_pause from commandbutton within w_main
integer x = 2432
integer y = 128
integer width = 366
integer height = 128
integer taborder = 10
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
boolean default = true
end type

event clicked;// Pause or unpause the sweeper process.
f_pause()
end event

