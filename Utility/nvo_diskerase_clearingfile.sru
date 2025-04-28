HA$PBExportHeader$nvo_diskerase_clearingfile.sru
forward
global type nvo_diskerase_clearingfile from nvo
end type
end forward

global type nvo_diskerase_clearingfile from nvo
end type
global nvo_diskerase_clearingfile nvo_diskerase_clearingfile

type variables
string is_boxno, is_googleboxno, is_drivespartno, is_drivesserialno, is_manpartno, is_location
date idt_stockdate
end variables

forward prototypes
public function boolean f_getboxno (ref string as_boxno)
public function boolean f_getstockdate (ref date adt_stockdate)
public function boolean f_getgoogleboxno (ref string as_googleboxno)
public function boolean f_getdrivesserialno (ref string as_drivespartno)
public function boolean f_getdrivepartno (ref string as_drivepartsno)
public function boolean f_getmanpartno (ref string as_manpartno)
public function boolean f_getlocation (ref string as_location)
public function boolean f_setboxno (string as_boxno)
public function boolean f_setstockdate (date adt_stockdate)
public function boolean f_setgoogleboxno (string as_googleboxno)
public function boolean f_setdrivesserialno (string as_drivespartno)
public function boolean f_setdrivepartno (string as_drivepartsno)
public function boolean f_setmanpartno (string as_manpartno)
public function boolean f_setlocation (string as_location)
end prototypes

public function boolean f_getboxno (ref string as_boxno);// set the argument to the instance.
as_boxno = is_boxno

// Return true
return true
end function

public function boolean f_getstockdate (ref date adt_stockdate);// Set the argument to the instance.
adt_stockdate = idt_stockdate

// Return true
return true
end function

public function boolean f_getgoogleboxno (ref string as_googleboxno);// set the argument to the instance.
as_googleboxno = is_googleboxno

// Return true
return true
end function

public function boolean f_getdrivesserialno (ref string as_drivespartno);// set the argument to the instance.
as_drivespartno = is_drivesserialno

// Return true
return true
end function

public function boolean f_getdrivepartno (ref string as_drivepartsno);// set the argument to the instance.
as_drivepartsno = is_drivespartno

// Return true
return true
end function

public function boolean f_getmanpartno (ref string as_manpartno);// set the argument to the instance.
as_manpartno = is_manpartno

// Return true
return true
end function

public function boolean f_getlocation (ref string as_location);// Set the argument to the instance.
as_location = is_location

// Return true
return true
end function

public function boolean f_setboxno (string as_boxno);// Set the instance to the argument.
is_boxno = as_boxno

// Return true
return true
end function

public function boolean f_setstockdate (date adt_stockdate);// Set the instance to the argument.
idt_stockdate = adt_stockdate

// Return true
return true
end function

public function boolean f_setgoogleboxno (string as_googleboxno);// Set the instance to the argument.
is_googleboxno = as_googleboxno

// Return true
return true
end function

public function boolean f_setdrivesserialno (string as_drivespartno);// Set the instance to the argument.
is_drivesserialno = as_drivespartno

// Return true
return true
end function

public function boolean f_setdrivepartno (string as_drivepartsno);// Set the instance to the argument.
is_drivespartno = as_drivepartsno

// Return true
return true
end function

public function boolean f_setmanpartno (string as_manpartno);// Set the instance to the argument.
is_manpartno = as_manpartno

// Return true
return true
end function

public function boolean f_setlocation (string as_location);// Set the instance to the argument.
is_location = as_location

// Return true
return true
end function

on nvo_diskerase_clearingfile.create
call super::create
end on

on nvo_diskerase_clearingfile.destroy
call super::destroy
end on

