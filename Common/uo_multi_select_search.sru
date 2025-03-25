HA$PBExportHeader$uo_multi_select_search.sru
forward
global type uo_multi_select_search from userobject
end type
type dw_search from datawindow within uo_multi_select_search
end type
end forward

global type uo_multi_select_search from userobject
integer width = 667
integer height = 280
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_search dw_search
end type
global uo_multi_select_search uo_multi_select_search

type variables

string is_search_column_name, is_dw_column_name


end variables

forward prototypes
public function integer uf_clear_list ()
public function string uf_build_search (boolean iswhere)
public function integer uf_init (string arg_search_dw_list, string arg_search_database, string arg_search_column_name)
public subroutine uf_set_selected (string as_status)
public subroutine uf_set_filter (string as_data)
public function boolean uf_init_selected (string as_selected_string)
public function string uf_build_component_list (boolean iswhere)
end prototypes

public function integer uf_clear_list ();
integer li_idx, li_rowcount

li_rowcount = dw_search.rowcount()

for li_idx = 1 to li_rowcount
	
	dw_search.SetItem( li_idx, "selected", 0)
	
next

return 1
end function

public function string uf_build_search (boolean iswhere);string ls_search_string
integer li_idx, li_rowcount
boolean lb_found = false

if IsWhere then
	
	ls_search_string = " AND " 
	
end if

ls_search_string = ls_search_string + is_search_column_name + " IN ( "

li_rowcount = dw_search.rowcount()

for li_idx = 1 to li_rowcount
	
	if dw_search.GetItemNumber( li_idx, "selected") = 1 then
		
		if lb_found then 
			ls_search_string = ls_search_string + ", " 
		end if
		
		ls_search_string = ls_search_string + "'" + dw_search.GetItemString(li_idx, is_dw_column_name) + "'"
		
		lb_found = true
		
	end if

	
next

if lb_found then
		
	ls_search_string = ls_search_string + ") "

else
	
	ls_search_string = ""
	
end if

	
return ls_search_string
end function

public function integer uf_init (string arg_search_dw_list, string arg_search_database, string arg_search_column_name);
//arg_search_dw_list - The datawindow used in the search selection window. 
//								Must contain a column named "selected"

// arg_search_database - Column in the database that is searched against.

// arg_search_column_name - Column in the search datawindow to use in the IN ( ) for the search.

dw_search.dataobject = arg_search_dw_list

is_search_column_name = arg_search_database
is_dw_column_name = arg_search_column_name

dw_search.setfilter( "") //07-Apr-2018 Madhu PEVS-517 -Removed filter
dw_search.filter( ) //07-Apr-2018 Madhu PEVS-517 -Removed filter

return 1
end function

public subroutine uf_set_selected (string as_status);/* Function created by GailM for Pandora Issue #605 - To allow dashboard to set status */

integer li_idx, li_rowcount
boolean lb_found = false

li_rowcount = dw_search.rowcount()

for li_idx = 1 to li_rowcount
		if dw_search.GetItemString( li_idx, is_dw_column_name) = as_status then
			dw_search.setitem(li_idx,"selected",1)
		end if
next

return
end subroutine

public subroutine uf_set_filter (string as_data);//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes
//Added Filter to minimize the dropdown list

String lsFind

lsFind = is_dw_column_name +" like '"+as_data+"%'"
dw_search.setfilter( lsFind)
dw_search.filter( )
end subroutine

public function boolean uf_init_selected (string as_selected_string);string  lstemp, ls_component,  ls_componentList, lsFind
integer li_rowcount
long llFindRow

//string is_selected_string //TAM 05/2017 PEVS-420
ls_componentList =as_selected_string

If Not IsNull(ls_componentList) and ls_componentList<>'' Then
	lsTemp = ls_componentList
	do while lsTemp <> ''
		If Pos(lsTemp,'|') > 0 Then
			 ls_component = Left(lsTemp,(pos(lsTemp,'|') - 1))
			 lsTemp = Right(lsTemp,(len(lsTemp) - (Len(ls_component) + 1))) /*strip off to next Commodity */
		Else 
			 ls_component = lsTemp
			 lsTemp = ''
		End If
		lsFind =   is_dw_column_name +   " = '" + ls_component + "'" 
		llFindRow = dw_search.Find(lsFind,1,dw_search.RowCount())
		If llFindRow > 0 Then
			 dw_search.SetItem( llFindRow, "selected", 1)			
		End If

	loop

End If
	
Return true
end function

public function string uf_build_component_list (boolean iswhere);string ls_component_list
integer li_idx, li_rowcount
boolean lb_found = false


ls_component_list = ''

li_rowcount = dw_search.rowcount()

for li_idx = 1 to li_rowcount
	
	if dw_search.GetItemNumber( li_idx, "selected") = 1 then
		
		if lb_found then 
			ls_component_list = ls_component_list + "|" 
		end if
		
		ls_component_list = ls_component_list + dw_search.GetItemString(li_idx, is_dw_column_name)
		
		lb_found = true
		
	end if

	
next

if not lb_found then
		
	ls_component_list = ""
	
end if

	
return ls_component_list
end function

on uo_multi_select_search.create
this.dw_search=create dw_search
this.Control[]={this.dw_search}
end on

on uo_multi_select_search.destroy
destroy(this.dw_search)
end on

type dw_search from datawindow within uo_multi_select_search
integer width = 663
integer height = 272
integer taborder = 10
string title = "none"
string dataobject = "d_ord_status_search_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

