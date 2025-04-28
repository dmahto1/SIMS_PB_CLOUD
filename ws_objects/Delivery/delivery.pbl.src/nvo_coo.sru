$PBExportHeader$nvo_coo.sru
forward
global type nvo_coo from nvo
end type
end forward

global type nvo_coo from nvo
end type
global nvo_coo nvo_coo

forward prototypes
public function boolean f_validatecoo (string as_coo, ref boolean ab_isvalid)
end prototypes

public function boolean f_validatecoo (string as_coo, ref boolean ab_isvalid);long ll_numcountries
boolean lb_goodvalidation

// Derrive lb_goodvalidation
lb_goodvalidation = len(as_coo) > 0

// See if the code exists in the country table.
Select count(*)
Into :ll_numcountries
From country
Where emcn_code = :as_coo
Using SQLCA;

// If there is a country with that code,
If ll_numcountries > 0 then
	
	// Set ab_isvalid true.
	ab_isvalid = true	
End IF

// Return lb_goodvalidation
return lb_goodvalidation
end function

on nvo_coo.create
call super::create
end on

on nvo_coo.destroy
call super::destroy
end on

