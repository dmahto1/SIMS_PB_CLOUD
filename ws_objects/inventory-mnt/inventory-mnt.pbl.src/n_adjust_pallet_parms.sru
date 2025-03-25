$PBExportHeader$n_adjust_pallet_parms.sru
forward
global type n_adjust_pallet_parms from nonvisualobject
end type
end forward

global type n_adjust_pallet_parms from nonvisualobject
end type
global n_adjust_pallet_parms n_adjust_pallet_parms

type variables
constant String BREAK_PALLET_APART = 'B'
constant String MERGE_PALLET = 'M'
constant String BREAK_CARTON_APART = 'C'
constant String MERGE_CARTON = 'D'
constant String MERGE_FOOTPRINT = 'F' // TAM S29817

constant int STATUS_SUCCESS = 1
constant int STATUS_ERROR = -1

int ii_status
boolean ib_some_cartons_broken
boolean ib_some_serials_broken
boolean ib_cancelled

String is_adjustment_type

String is_project
String is_warehouse
String is_sku
String is_sscc_nr
String is_sscc_nr_new
String is_carton_id
String is_carton_id_new
String is_serial_in_string_merge
String is_to_scan_type // TAM S29817
String is_to_pallet_type // TAM S29817


DataStore ids_content_rs
DataStore ids_pallet_association
DataStore ids_carton_list
DataStore ids_pallet_carton_list // TAM S29817
DataStore ids_carton_serial_footprint // TAM S29817
DataStore ids_carton_serial

long il_sum_carton_count
long il_sum_serial_count

end variables

forward prototypes
public function long of_load_datastores ()
public subroutine of_set_status ()
public function boolean of_execution_successfull ()
public function string of_get_parms_display ()
public function boolean of_contains_carton (string as_carton)
public function string of_get_container_in_string ()
public subroutine of_increment_carton_count (string as_carton)
public function long of_add_pallet (string as_pallet_id_from, string as_pallet_id_to, long al_quantity)
public function string of_build_pallet_in_string ()
public function string of_get_serial_in_string ()
public function long of_load_serials ()
public function boolean of_contains_serial (string as_serial)
public subroutine of_increment_serial_count (string as_serial)
public function string of_set_serial_in_string_merge (listbox alb_serial_list)
public function string of_get_serial_in_string_merge ()
public function long of_add_pallet_from_merge (string as_pallet_id_from, string as_pallet_id_to, long al_quantity)
public function long of_add_carton (string as_carton_no)
public function string of_build_carton_in_string ()
public function boolean of_contains_footprint_carton (string as_pallet, string as_carton)
public function long of_add_footprint_carton (string as_pallet_id, string as_carton_id, long al_quantity)
public function boolean of_add_footprint_serial (string as_pallet, string as_carton)
end prototypes

public function long of_load_datastores ();long ll_rows
//ll_rows = ids_content_rs.Retrieve(is_project, this.is_warehouse, this.is_sku,  this.is_sscc_nr)
ll_rows = ids_content_rs.Retrieve(is_project, this.is_sku,  this.is_sscc_nr)

return ll_rows

end function

public subroutine of_set_status ();if is_adjustment_type = BREAK_PALLET_APART or is_adjustment_type = MERGE_PALLET then

	if ids_content_rs.RowCount() > 0 and ib_some_cartons_broken and NOT ib_cancelled then
		ii_status = STATUS_SUCCESS
	else
		ii_status = STATUS_ERROR	
	end if

elseif is_adjustment_type = BREAK_CARTON_APART then

	if ids_carton_serial.RowCount() > 0 and ib_some_serials_broken and NOT ib_cancelled then
		ii_status = STATUS_SUCCESS
	else
		ii_status = STATUS_ERROR	
	end if

elseif is_adjustment_type = MERGE_CARTON then

	if NOT ib_cancelled and NOT IsNull(is_serial_in_string_merge) and Len(Trim(is_serial_in_string_merge)) > 0 then
		ii_status = STATUS_SUCCESS
	else
		ii_status = STATUS_ERROR	
	end if

elseif is_adjustment_type = MERGE_FOOTPRINT then  //TAM - 2019/03 - S29817 - Footprints Mixed containers

	if NOT ib_cancelled and ((NOT IsNull(is_serial_in_string_merge) and Len(Trim(is_serial_in_string_merge)) > 0) or ids_pallet_carton_list.RowCount() > 0)  then
		ii_status = STATUS_SUCCESS
	else
		ii_status = STATUS_ERROR	
	end if

end if

end subroutine

public function boolean of_execution_successfull ();if ii_status = STATUS_SUCCESS then
	return true
else
	return false
end if
end function

public function string of_get_parms_display ();//return "Project: " + is_project + "~rWarehouse: " + is_warehouse + "~rSKU: " + is_sku + "~rSSCC#: " + is_sscc_nr

if is_adjustment_type = BREAK_PALLET_APART or is_adjustment_type = MERGE_PALLET then
	return "Project: " + is_project + "~rWarehouse: " + is_warehouse + "~rSKU: " + is_sku + "~rSSCC#: " + is_sscc_nr
else
	return "Project: " + is_project + "~rWarehouse: " + is_warehouse + "~rSKU: " + is_sku + "~rCarton ID#: " + is_carton_id
end if
end function

public function boolean of_contains_carton (string as_carton);long ll_row 
//ll_row = ids_content_rs.Find("container_id = '" + as_carton + "'", 1, ids_content_rs.RowCount())
ll_row = ids_content_rs.Find("carton_id = '" + as_carton + "'", 1, ids_content_rs.RowCount())

if ll_row > 0 then
	return true
else
	return false
end if

end function

public function string of_get_container_in_string ();String ls_values

if ids_content_rs.RowCount() = 0 then
	return "(null)"
end if

long i
for i = 1 to ids_content_rs.RowCount()
	
	if Len(ls_values) = 0 then
		ls_values += "'" + ids_content_rs.object.carton_id[i] + "'"
	else
		ls_values += ", '" + ids_content_rs.object.carton_id[i] + "'"	
	end if

next

return "(" + ls_values + ")"

end function

public subroutine of_increment_carton_count (string as_carton);long ll_row
ll_row = ids_content_rs.Find("carton_id = '" + as_carton + "'", 1, ids_content_rs.RowCount())

if ll_row > 0 then
	il_sum_carton_count = il_sum_carton_count + Long(ids_content_rs.Object.carton_count[ll_row])
end if

end subroutine

public function long of_add_pallet (string as_pallet_id_from, string as_pallet_id_to, long al_quantity);long ll_return
long ll_row

ll_row = ids_pallet_association.InsertRow(0)
if ll_row > 0 then
	ids_pallet_association.Object.pallet_from[ll_row] = as_pallet_id_from
	ids_pallet_association.Object.pallet_to[ll_row] = as_pallet_id_to
	ids_pallet_association.Object.quantity[ll_row] = al_quantity
	ll_return = 1
else
	ll_return = -1
end if

return ll_return

end function

public function string of_build_pallet_in_string ();String ls_values

if ids_pallet_association.RowCount() = 0 then
	return "(null)"
end if

long i
for i = 1 to ids_pallet_association.RowCount()
	
	if i = 1 then
		// Add the "To" pallet id once here
		ls_values = "'" + ids_pallet_association.object.pallet_to[i] + "'"
	end if
	
	if Pos(ls_values, ids_pallet_association.object.pallet_from[i]) = 0 then
		if Len(ls_values) = 0 then
			ls_values += "'" + ids_pallet_association.object.pallet_from[i] + "'"
		else
			ls_values += ", '" + ids_pallet_association.object.pallet_from[i] + "'"	
		end if
	end if	
next

return "(" + ls_values + ")"

end function

public function string of_get_serial_in_string ();String ls_values

if ids_carton_serial.RowCount() = 0 then
	return "(null)"
end if

long i
for i = 1 to ids_carton_serial.RowCount()
	
	if Len(ls_values) = 0 then
		ls_values += "'" + ids_carton_serial.object.serial_no[i] + "'"
	else
		ls_values += ", '" + ids_carton_serial.object.serial_no[i] + "'"	
	end if
next

return "(" + ls_values + ")"

end function

public function long of_load_serials ();return ids_carton_serial.Retrieve(is_project, is_carton_id)

end function

public function boolean of_contains_serial (string as_serial);long ll_row 

ll_row = ids_carton_serial.Find("serial_no = '" + as_serial + "'", 1, ids_carton_serial.RowCount())

if ll_row > 0 then
	return true
else
	return false
end if

end function

public subroutine of_increment_serial_count (string as_serial);long ll_row
ll_row = ids_carton_serial.Find("serial_no = '" + as_serial + "'", 1, ids_carton_serial.RowCount())

if ll_row > 0 then
	il_sum_serial_count = il_sum_serial_count + 1
end if

end subroutine

public function string of_set_serial_in_string_merge (listbox alb_serial_list);String ls_serial, ls_serial_in_string
int j
long ll_row

//TAM 2019/03 -S29817 - Mixed Containerization - Return (Null)
if alb_serial_list.TotalItems() < 1 then
	is_serial_in_string_merge = "(null)"
	return is_serial_in_string_merge
end if

for j = 1 to alb_serial_list.TotalItems()

	ls_serial = "'" + alb_serial_list.Text(j) + "'"
	if j = 1 then
		ls_serial_in_string = ls_serial
	else
		ls_serial_in_string += ", " + ls_serial		
	end if	
next

is_serial_in_string_merge = " (" + ls_serial_in_string + ") "

return is_serial_in_string_merge

end function

public function string of_get_serial_in_string_merge ();return is_serial_in_string_merge
end function

public function long of_add_pallet_from_merge (string as_pallet_id_from, string as_pallet_id_to, long al_quantity);long ll_return
long ll_row

ll_row = ids_pallet_association.InsertRow(0)
if ll_row > 0 then
	ids_pallet_association.Object.pallet_from[ll_row] = as_pallet_id_from
	ids_pallet_association.Object.pallet_to[ll_row] = as_pallet_id_to
	ids_pallet_association.Object.quantity[ll_row] = al_quantity
	ll_return = 1
else
	ll_return = -1
end if

return ll_return

end function

public function long of_add_carton (string as_carton_no);long ll_return
long ll_row

ll_row = ids_carton_list.InsertRow(0)
if ll_row > 0 then
	ids_carton_list.Object.carton_no[ll_row] = as_carton_no
	ll_return = 1
else
	ll_return = -1
end if

return ll_return

end function

public function string of_build_carton_in_string ();String ls_values

if ids_carton_list.RowCount() = 0 then
	return "(null)"
end if

long i
for i = 1 to ids_carton_list.RowCount()
	
	if i = 1 then
		ls_values = "'" + ids_carton_list.object.carton_no[i] + "'"
	else
			ls_values += ", '" + ids_carton_list.object.carton_no[i] + "'"	
	end if
next

return "(" + ls_values + ")"

end function

public function boolean of_contains_footprint_carton (string as_pallet, string as_carton);long ll_row 
ll_row = ids_pallet_carton_list.Find("pallet_id = '" + as_pallet + "' and carton_id = '" + as_carton + "'", 1, ids_pallet_carton_list.RowCount())

if ll_row > 0 then
	return true
else
	return false
end if

end function

public function long of_add_footprint_carton (string as_pallet_id, string as_carton_id, long al_quantity);long ll_return
long ll_row

ll_row = ids_pallet_carton_list.InsertRow(0)
if ll_row > 0 then
	ids_pallet_carton_list.Object.po_no2[ll_row] = as_pallet_id
	ids_pallet_carton_list.Object.carton_id[ll_row] = as_carton_id
	ids_pallet_carton_list.Object.qty[ll_row] = al_quantity
	ll_return = 1
else
	ll_return = -1
end if

return ll_return

end function

public function boolean of_add_footprint_serial (string as_pallet, string as_carton);long ll_row

ll_row = ids_pallet_carton_list.Find("po_no2 = '" + as_pallet + "' and carton_id = '" + as_carton + "'", 1, ids_pallet_carton_list.RowCount())

//update quantity of scanned carton 
if ll_row > 0 then
	ids_pallet_carton_list.Object.qty[ll_row] = ids_pallet_carton_list.Object.qty[ll_row] + 1
	return(false)
else
//add scanned carton 
	ll_row = ids_pallet_carton_list.InsertRow(0)
	ids_pallet_carton_list.Object.po_no2[ll_row] = as_pallet
	ids_pallet_carton_list.Object.carton_id[ll_row] = as_carton
	ids_pallet_carton_list.Object.qty[ll_row] = 1

	return(true)
end if




end function

on n_adjust_pallet_parms.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_adjust_pallet_parms.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_content_rs = Create datastore
ids_content_rs.Dataobject = 'd_content_pallet_adjust'
ids_content_rs.SetTransObject(sqlca)

ids_pallet_association = Create datastore
ids_pallet_association.Dataobject = 'd_pallet_association'
ids_content_rs.SetTransObject(sqlca)

ids_carton_serial = Create datastore
ids_carton_serial.Dataobject = 'd_carton_serial_by_carton_id'
ids_carton_serial.SetTransObject(sqlca)

// TAM 2018/02 S14838
ids_carton_list = Create datastore
ids_carton_list.Dataobject = 'd_carton_move_list'
ids_carton_list.SetTransObject(sqlca)

// TAM 2018/02 S29817 - Mixed Containerization
ids_pallet_carton_list = Create datastore
ids_pallet_carton_list.Dataobject = 'd_pallet_carton_move_list'
ids_pallet_carton_list.SetTransObject(sqlca)




end event

