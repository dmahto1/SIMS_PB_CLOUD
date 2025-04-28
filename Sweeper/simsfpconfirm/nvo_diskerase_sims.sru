HA$PBExportHeader$nvo_diskerase_sims.sru
forward
global type nvo_diskerase_sims from nvo
end type
end forward

global type nvo_diskerase_sims from nvo
end type
global nvo_diskerase_sims nvo_diskerase_sims

type variables
Private date idt_completedate
Private string is_inventorytype, is_lotnumber, is_ownercode, is_warehousecode, is_sku, is_lcode, is_coo
Private long il_availqty
end variables

forward prototypes
public function boolean f_setlcode (string as_lcode)
public function boolean f_setinventorytype (string as_inventorytype)
public function boolean f_setlotnumber (string as_lotnumber)
public function boolean f_setsku (string as_sku)
public function boolean f_setownercode (string as_ownercode)
public function boolean f_setcompletedate (date adt_completedate)
public function boolean f_getlcode (ref string as_lcode)
public function boolean f_getinventorytype (ref string as_inventorytype)
public function boolean f_getlotnumber (ref string as_lotnumber)
public function boolean f_getownercode (ref string as_ownercode)
public function boolean f_getcompletedate (ref date adt_completedate)
public function boolean f_setwarehousecode (string as_whcode)
public function boolean f_getsku (ref string as_sku)
public function boolean f_setavailqty (long al_availqty)
public function boolean f_getavailqty (ref long al_availqty)
public function boolean f_setcoo (string as_coo)
public function boolean f_getcoo (ref string as_coo)
end prototypes

public function boolean f_setlcode (string as_lcode);// set the instance to the argument
is_lcode = as_lcode

// Return true
return true
end function

public function boolean f_setinventorytype (string as_inventorytype);// set the instance to the argument
is_inventorytype = as_inventorytype

// Return true
return true
end function

public function boolean f_setlotnumber (string as_lotnumber);// set the instance to the argument
is_lotnumber = as_lotnumber

// Return true
return true
end function

public function boolean f_setsku (string as_sku);// set the instance to the argument
is_sku = as_sku

// Return true
return true
end function

public function boolean f_setownercode (string as_ownercode);// set the instance to the argument
is_ownercode = as_ownercode

// Return true
return true
end function

public function boolean f_setcompletedate (date adt_completedate);// set the instance to the argument
idt_completedate = adt_completedate

// Return true
return true
end function

public function boolean f_getlcode (ref string as_lcode);// set the instance to the argument
as_lcode = is_lcode

// Return true
return true
end function

public function boolean f_getinventorytype (ref string as_inventorytype);// Set the argument to the instance.
as_inventorytype = is_inventorytype

// Return true
return true
end function

public function boolean f_getlotnumber (ref string as_lotnumber);// Set the argument to the instance.
as_lotnumber = is_lotnumber

// Return true
return true
end function

public function boolean f_getownercode (ref string as_ownercode);// Set the argument to the instance.
as_ownercode = is_ownercode

// Return true
return true
end function

public function boolean f_getcompletedate (ref date adt_completedate);// Set the argument to the instance.
adt_completedate = idt_completedate

// Return true
return true
end function

public function boolean f_setwarehousecode (string as_whcode);// Set the instance to the argument.
is_warehousecode = as_whcode

// Return true
return true
end function

public function boolean f_getsku (ref string as_sku);// Set the argument to the instance.
as_sku = is_sku

// Return true
return true
end function

public function boolean f_setavailqty (long al_availqty);// Set the instance to the argument.
il_availqty = al_availqty

// Return true
return true
end function

public function boolean f_getavailqty (ref long al_availqty);// Set the argument to the instance.
al_availqty = il_availqty

// Return true
return true
end function

public function boolean f_setcoo (string as_coo);// Set the instance to the argument.
is_coo = as_coo

// Return true
return true
end function

public function boolean f_getcoo (ref string as_coo);// Set the argument to the instance
as_coo = is_coo

// Return true
return true
end function

on nvo_diskerase_sims.create
call super::create
end on

on nvo_diskerase_sims.destroy
call super::destroy
end on

