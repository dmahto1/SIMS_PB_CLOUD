$PBExportHeader$w_adjust_pallet.srw
forward
global type w_adjust_pallet from window
end type
end forward

global type w_adjust_pallet from window
integer width = 2021
integer height = 2140
boolean titlebar = true
string title = "Pallet Adjust"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_closing ( )
end type
global w_adjust_pallet w_adjust_pallet

type variables
w_adjust_create iw_parent
u_adjust_pallet iu_adjust_pallet
n_adjust_pallet_parms in_parms
u_adjust_pallet_merge iu_adjust_pallet_merge
u_adjust_pallet_merge_footprint iu_adjust_footprint_merge

u_adjust_carton iu_adjust_carton
u_adjust_carton_merge iu_adjust_carton_merge

end variables

event ue_closing();CloseWithReturn(this, in_parms)

end event

on w_adjust_pallet.create
end on

on w_adjust_pallet.destroy
end on

event open;// LTK 20131011	Pallet adjustment window.  Logic encapsulated in the user object.
in_parms = Message.PowerObjectParm

if in_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_PALLET_APART then
	OpenUserObjectWithParm(iu_adjust_pallet, this, 20, 20)	
	iu_adjust_pallet.SetFocus()
elseif in_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_PALLET then
	this.width = 2210
	OpenUserObjectWithParm(iu_adjust_pallet_merge, this, 20, 20)	
	iu_adjust_pallet_merge.SetFocus()
elseif in_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_CARTON_APART then
	OpenUserObjectWithParm(iu_adjust_carton, this, 20, 20)	
	iu_adjust_carton.SetFocus()
elseif in_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_CARTON then
	this.width = 2210
	OpenUserObjectWithParm(iu_adjust_carton_merge, this, 20, 20)	
	iu_adjust_carton_merge.SetFocus()
elseif in_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_FOOTPRINT then // TAM 2019/03 - S29817 Mixed Containerization
	this.width = 3210
	OpenUserObjectWithParm(iu_adjust_footprint_merge, this, 20, 20)	
	iu_adjust_footprint_merge.SetFocus()
else
	MessageBox("Error", "Coding error.  Expected pallet adjustment type not sent.")
end if

end event

