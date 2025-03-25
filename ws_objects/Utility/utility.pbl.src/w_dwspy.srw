$PBExportHeader$w_dwspy.srw
forward
global type w_dwspy from w
end type
type dw_spy from u_dw within w_dwspy
end type
end forward

global type w_dwspy from w
event type boolean e_postopen ( )
dw_spy dw_spy
end type
global w_dwspy w_dwspy

type variables
Protected powerobject ipo
end variables

event type boolean e_postopen();// Original design by KZUV.COM

object lo_typeof
datawindow ldw
datastore lds
boolean lb_error

// Get the typeof the powerobject.
lo_typeof = ipo.typeof()

// What typeof is the powerobject.
Choose Case lo_typeof
		
	// Datawindow
	Case Datawindow!
		
		// Set ipo to the local datawindow
		ldw = ipo
		
		// Set the dwspy dataobject.
		dw_spy.dataobject = ldw.dataobject
	
		// Share the instance dw.
		ldw.sharedata(dw_spy)
		
	// Datastore
	Case DataStore!
		
		// Set ipo to the local datawindow
		lds = ipo
		
		// Set the dwspy dataobject.
		dw_spy.dataobject = lds.dataobject
	
		// Share the instance dw.
		lds.sharedata(dw_spy)
	
	// Anything Else
	Case Else
		
		// Error
		messagebox("w_dwspy - Invalid powerobject type", "You may pass only a datawindow or datastore to the dwspy for processing")
		
		// Set the error flag.
		lb_error = true
	
// End What typeof is the powerobject.
End Choose

// Return not lb_error
return not lb_error
end event

on w_dwspy.create
int iCurrent
call super::create
this.dw_spy=create dw_spy
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_spy
end on

on w_dwspy.destroy
call super::destroy
destroy(this.dw_spy)
end on

event open;call super::open;// Original design by KZUV.COM

// Get the datawindow or datastore.
ipo = message.powerobjectparm

// Post the e_postopen event.
Post Event e_postopen()
end event

event resize;call super::resize;// Move and size the dw spy.
dw_spy.x = 20
dw_spy.y = 20
dw_spy.width = width - 40
dw_spy.height = height - 200
end event

type dw_spy from u_dw within w_dwspy
integer x = 347
integer y = 624
boolean hscrollbar = true
boolean vscrollbar = true
end type

