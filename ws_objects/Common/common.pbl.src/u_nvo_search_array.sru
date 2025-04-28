$PBExportHeader$u_nvo_search_array.sru
forward
global type u_nvo_search_array from nonvisualobject
end type
end forward

global type u_nvo_search_array from nonvisualobject
end type
global u_nvo_search_array u_nvo_search_array

forward prototypes
public function datastore uf_ds_from_array (ref long al_arr[])
public function string uf_get_pb_version ()
public function datastore uf_ds_from_array (ref string as_arr[])
public function boolean uf_value_exists_in_array (string as_val, ref string rs_arr[], ref long al_return_array_row)
end prototypes

public function datastore uf_ds_from_array (ref long al_arr[]);/*----------------------------------------------------------------------------------------------------------------------
Acc:   public
-----------------------------------------------------------------------------------------------------------------------
Dscr:   Gets decimal array and creates a DS, the only column of which (named 'the_col') contains the array's values.
------------------------------------------------------------------------------------------------------------------------
Arg:   al_arr[] - long array to convert to DataStore
------------------------------------------------------------------------------------------------------------------------
Ret:   DataStore
----------------------------------------------------------------------------------------------------------------------*/
string      ls_source
string      ls_error
string      ls_pb_version
DataStore   lds

ls_pb_version = uf_get_pb_version()
ls_source = 'release ' + ls_pb_version + '; datawindow() table(column=(type=decimal(0) name=the_col dbname="the_col") )'

lds = create DataStore
lds.create(ls_source, ls_error)

if UpperBound(al_arr ) > 0 then
   lds.object.the_col.current = al_arr
end if

return lds
end function

public function string uf_get_pb_version ();/*----------------------------------------------------------------------------------------------------------------------
Acc:   public
-----------------------------------------------------------------------------------------------------------------------
Dscr:   returns the major version number of PowerBuilder, for example: "9" (not "9.0"!)
------------------------------------------------------------------------------------------------------------------------
Ret:   PB version as string
----------------------------------------------------------------------------------------------------------------------*/
string      ls_pb_version
int         li_rc
environment   lenv

li_rc = GetEnvironment(ref lenv)
if li_rc <> 1 then return '<<<Error in n_util.uf_get_pb_version>>>'

ls_pb_version = String(lenv.pbmajorrevision)

return ls_pb_version

//Some more fields which can be useful:
//lenv.pbminorrevision
//lenv.pbfixesrevision
//lenv.pbbuildnumber
end function

public function datastore uf_ds_from_array (ref string as_arr[]);/*----------------------------------------------------------------------------------------------------------------------
Acc:   public
-----------------------------------------------------------------------------------------------------------------------
Dscr:   Gets string array and creates a DS, the only column of which (named "the_col") contains the array's values.
------------------------------------------------------------------------------------------------------------------------
Arg:   as_arr[] - string array to convert to DataStore
------------------------------------------------------------------------------------------------------------------------
Ret:   DataStore
----------------------------------------------------------------------------------------------------------------------*/
string      ls_source
string      ls_error
string      ls_pb_version
DataStore   lds

ls_pb_version = uf_get_pb_version()
ls_source = 'release ' + ls_pb_version + '; datawindow() table(column=(type=char(10000) name=the_col dbname="the_col") )'

lds = create DataStore
lds.create(ls_source, ls_error)

if UpperBound(as_arr) > 0 then
   lds.object.the_col.current = as_arr
end if

return lds
end function

public function boolean uf_value_exists_in_array (string as_val, ref string rs_arr[], ref long al_return_array_row);/**********************************************************************************************************************
Acc:   public
-----------------------------------------------------------------------------------------------------------------------
Dscr:   Reports if the value exists in the array.
-----------------------------------------------------------------------------------------------------------------------
Arg:   as_val
      rs_arr[] (ref)
-----------------------------------------------------------------------------------------------------------------------
**********************************************************************************************************************/
long         ll_upper_bound
long         ll_row
DataStore   lds_temp

al_return_array_row = 0

//if uf_empty(as_val) then
//   f_throw(PopulateError(0, "Arg as_val is empty."))
//end if

// If array is small then we can LOOP:
ll_upper_bound = UpperBound ( rs_arr [ ] )
if ll_upper_bound <= 1000 then
   for ll_row = 1 to ll_upper_bound
      if rs_arr [ ll_row ] = as_val then
		//Passed by Ref to return the row that was found in the array.
		al_return_array_row = ll_row
         return true
      end if
   next
   return false
end if

// Array is large - it's faster to deal with DataStore:
lds_temp = uf_ds_from_array(rs_arr [ ] ) 
lds_temp.object.the_col.current = rs_arr [ ]
ll_row = lds_temp.Find("the_col='" + as_val + "'", 1, ll_upper_bound )
destroy lds_temp
al_return_array_row = ll_row
return (ll_row > 0 )

end function

on u_nvo_search_array.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_search_array.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

