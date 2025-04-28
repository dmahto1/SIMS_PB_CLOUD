$PBExportHeader$nvo_order.sru
forward
global type nvo_order from nvo
end type
end forward

global type nvo_order from nvo
end type
global nvo_order nvo_order

forward prototypes
public function boolean f_getcostcenter (long al_pickrow, ref decimal ad_cost)
end prototypes

public function boolean f_getcostcenter (long al_pickrow, ref decimal ad_cost);string ls_ownercode, ls_cost
long ll_ownerid
			
// Get the cost from the order.
//Jxlim 02/01/2012 BRD #337 If calling from w_shipments
If Not IsValid(w_do) and IsValid(w_Shipments) Then
	ad_cost =dec(w_shipments.ids_do_Main.GetITemString(1,'user_field10'))
Else
	ad_cost = dec(w_do.idw_Main.GetITemString(1,'user_field10'))
End If

// If the cost is 0,
If ad_cost = 0 or isnull(ad_cost) then

	// Get the owner id.
	//Jxlim 02/01/2012 BRD #337 If calling from w_shipments
	If Not IsValid(w_do) and IsValid(w_Shipments) Then
		ll_ownerid =  w_shipments.ids_do_detail.GetITemNUmber(al_pickrow,'owner_id')
	Else
		//ll_ownerid =  w_do.ids_do_detail.GetITemNUmber(al_pickrow,'owner_id')	
		//change the retrive object data window .nxjain 06132016
		ll_ownerid =  w_do.idw_pick.GetITemNUmber(al_pickrow,'owner_id')		
	End If
	
	// Get the owner code
	SELECT owner_cd 
	INTO :ls_ownercode 
	FROM Owner
	Where Project_id = :gs_project and owner_id = :ll_ownerid;
	
	// Get the cost from customer master.
	Select user_field7 
	into :ls_cost 
	from customer 
	where project_id = 'PANDORA' 
	and cust_code = :ls_ownercode;	
	
	// convert string to a decimal.
	ad_cost = dec(ls_cost)

// End if the cost is 0.
End If

// Return ad_cost > 0
return ad_cost > 0
end function

on nvo_order.create
call super::create
end on

on nvo_order.destroy
call super::destroy
end on

