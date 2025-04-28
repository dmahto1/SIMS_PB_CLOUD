HA$PBExportHeader$nvo_country.sru
forward
global type nvo_country from nvo
end type
end forward

global type nvo_country from nvo
end type
global nvo_country nvo_country

forward prototypes
public function boolean f_exchangecodes (string as_origcode, ref string as_newcode)
public function boolean f_getnameforcode (string as_countrycode, ref string as_countryname)
end prototypes

public function boolean f_exchangecodes (string as_origcode, ref string as_newcode);boolean lb_foundcode
string ls_find, ls_findfield
long ll_row

// Default lb_foundcode to true.
lb_foundcode = true

// IF the length of the original code is 2,
If Len(Trim(as_origcode)) = 2 Then
	
	// Define the find and findfield values.
	ls_find = "Upper(designating_Code) = '" + upper(as_origcode) + "'"
	ls_findfield = "iso_country_cd"
	
// Otherwise, if the length of the original code is 3,
ElseIf Len(Trim(as_origcode)) = 3 Then
	
	ls_find = "Upper(iso_Country_cd) = '" + upper(as_origcode) + "'"
	ls_findfield = "designating_Code"
	
// Otherwise,
Else
	
	// Otherwise, set lb_foundcode to false.
	lb_foundcode = false
	
// end if the length of the original code is 3.
End If

// If lb_gotcode is still good,
If lb_foundcode then

	// Get the row matching the passed in value.
	ll_row = g.ids_country.Find(ls_find,1,g.ids_country.rowCount())
	
	If ll_row > 0 Then
		
		// Set lb_foundcode to true
		as_newcode = g.ids_country.GetITemString(ll_row, ls_findfield)
	Else
		as_newcode = ""
		
		// Set lb_foundcode to false
		lb_foundcode = false
	End If
End If

// Return lb_foundcode
return lb_foundcode
end function

public function boolean f_getnameforcode (string as_countrycode, ref string as_countryname);String	lsCountryName, lsFind
Long		llCountryNo, llFindRow
boolean lb_foundcode

//01/06 - PCONKL - We already have the country table loaded in memory

If Len(Trim(as_countrycode)) = 2 Then /*2 char Country Code*/
	
	lsFind = "Upper(designating_Code) = '" + upper(as_countrycode) + "'"
	
Else /*use 3 char Code*/
	
	lsFind = "Upper(iso_Country_cd) = '" + upper(as_countrycode) + "'"
	
End If

llFindRow = g.ids_country.Find(lsFind,1,g.ids_country.rowCount())

If llFindRow > 0 Then
	
	// Set lb_foundcode to true
	lb_foundcode = true
	as_countryname = g.ids_country.GetITemString(llFindRow,'country_Name')
Else
	as_countryname = ""
End If

Return lb_foundcode
end function

on nvo_country.create
call super::create
end on

on nvo_country.destroy
call super::destroy
end on

