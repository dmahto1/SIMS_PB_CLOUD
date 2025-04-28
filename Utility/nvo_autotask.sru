HA$PBExportHeader$nvo_autotask.sru
forward
global type nvo_autotask from nvo
end type
end forward

global type nvo_autotask from nvo
end type
global nvo_autotask nvo_autotask

type variables
Private w_do iw_do
end variables

forward prototypes
public function boolean f_reconfirm (string as_orderno)
public function boolean f_getoutboundbyorderno (string as_orderno)
public function boolean f_opendelivery ()
end prototypes

public function boolean f_reconfirm (string as_orderno);w_do lw_do
Str_parms	lStrparms
boolean lb_goodconfirm

// If we can get the outbound order using the order number.
if f_getoutboundbyorderno(as_orderno) then
	
	// Set lb_goodconfirm to true
	lb_goodconfirm = true
	return lb_goodconfirm
	// Click the confirm button.
	iw_do.Event ue_confirm()
End If

// Return lb_goodconfirm
return lb_goodconfirm
end function

public function boolean f_getoutboundbyorderno (string as_orderno);boolean lb_goodconfirm

// If we can open the delivery window.
If f_opendelivery() then
	
	// Make lb_goodconfirm true
	lb_goodconfirm = true

	// Set the search terms in the window
	iw_do.tab_main.tabpage_main.sle_order.text = as_orderno

	// Retrieve the order.
	iw_do.tab_main.tabpage_main.sle_order.Event modified()
End If

// Return lb_goodconfirm
return lb_goodconfirm

// MORK00000192381






  
end function

public function boolean f_opendelivery ();str_parms Lstrparms
boolean lb_goodopen = true

// If we have access,
If f_check_access ("W_DOR","") = 1 Then
	
	// Open the delivery order window.
	Lstrparms.String_arg[1] = "W_DOR"
	OpenSheetwithparm(iw_do,lStrparms, w_main, gi_menu_pos, Original!)
	iw_do.Event ue_postopen()
	
//	// Make the delivery order window invisible to eliminate confusion.
//	iw_do.visible = false
End If

// Set is_Ready_Or_Confirm to show were 're-confirming' rather than 'ready to ship'ping. 
iw_do.is_Ready_Or_Confirm = 'CONFIRM'

// Return lb_goodopen
return lb_goodopen
end function

on nvo_autotask.create
call super::create
end on

on nvo_autotask.destroy
call super::destroy
end on

event destructor;call super::destructor;// Close the delivery window.
//close(iw_do)
end event

