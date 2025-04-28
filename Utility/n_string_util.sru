HA$PBExportHeader$n_string_util.sru
forward
global type n_string_util from nonvisualobject
end type
end forward

global type n_string_util from nonvisualobject
end type
global n_string_util n_string_util

type variables
constant int FORMAT1 = 1		// Single quoted and separated by commas such as
										// 'str1', 'str2', ...
										
constant int FORMAT2 = 2		// Same as FORMAT1 without single quotes
										// str1, str2, ...

end variables

forward prototypes
public function string of_string_replace (string as_source_string, string as_token_to_find, string as_replace_with_this)
public function string of_format_string (string as_array_of_strings[], integer ai_format)
public function boolean uf_contains (any ao_string_array, string as_target)
end prototypes

public function string of_string_replace (string as_source_string, string as_token_to_find, string as_replace_with_this);/*
	Within a given a source string, recursively replace all occurrences of string x with string y.
	Example: to replace all carriage return and line feeds within the source string, 
	with spaces, make the following call:
	
		of_string_replace(ls_source_string, "~r~n", "  ")
*/

// LTK 20111206	Added this method utility.
if Pos(as_source_string, as_token_to_find) > 0 then
	as_source_string = Replace(as_source_string, Pos(as_source_string, as_token_to_find), Len(as_token_to_find), as_replace_with_this)
	return of_string_replace(as_source_string, as_token_to_find, as_replace_with_this)
else
	// base case
	return as_source_string
end if

end function

public function string of_format_string (string as_array_of_strings[], integer ai_format);/*

	Accept an array of strings and return a string with array members in various formats.

*/

// LTK 20111206	Pandroa #335 Added method utility to support this fix.
String ls_return
Long i

if Not IsNull(as_array_of_strings) then
	Long ll_array_size
	ll_array_size = UpperBound(as_array_of_strings)
	if ll_array_size > 0 then
		
		choose case ai_format

			case FORMAT1
				// Single quoted and separated by commas
				for i = 1 to ll_array_size
					if Len(ls_return) = 0 then
						ls_return = "'" + as_array_of_strings[i] + "'"
					else
						ls_return += ",'" + as_array_of_strings[i] + "'"				
					end if
				next
	
				case FORMAT2
				// Single quoted and separated by commas
				for i = 1 to ll_array_size
					if Len(ls_return) = 0 then
						ls_return = as_array_of_strings[i]
					else
						ls_return += "," + as_array_of_strings[i]
					end if
				next

		end choose
	end if
end if

return ls_return

end function

public function boolean uf_contains (any ao_string_array, string as_target);boolean lb_return
String ls_source_array[]
long i

ls_source_array = ao_string_array

for i = 1 to UpperBound( ls_source_array )
	if Upper( Trim( ls_source_array[ i ] ) ) = Upper( Trim( as_target ) ) then
		lb_return = TRUE
		exit
	end if
next

return lb_return

end function

on n_string_util.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_string_util.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

