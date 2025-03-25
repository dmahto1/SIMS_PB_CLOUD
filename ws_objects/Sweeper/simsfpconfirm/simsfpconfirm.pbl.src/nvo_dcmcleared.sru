$PBExportHeader$nvo_dcmcleared.sru
forward
global type nvo_dcmcleared from nvo
end type
end forward

global type nvo_dcmcleared from nvo
end type
global nvo_dcmcleared nvo_dcmcleared

type variables
Protected string is_boxno, is_location, is_status
end variables

forward prototypes
public function boolean f_setboxno (string as_boxno)
public function boolean f_setlocation (string as_boxno)
public function boolean f_setstatus (string as_boxno)
public function boolean f_getboxno (ref string as_boxno)
public function boolean f_getlocation (ref string as_location)
public function boolean f_getstatus (ref string as_boxno)
end prototypes

public function boolean f_setboxno (string as_boxno);// Set the instance to the argument.
is_boxno = as_boxno

// Return true
return true
end function

public function boolean f_setlocation (string as_location);// Set the instance to the argument.
is_location = as_location

// Return true
return true
end function

public function boolean f_setstatus (string as_status);// Set the instance to the argument.
is_status = as_status

// Return true
return true
end function

public function boolean f_getboxno (ref string as_boxno);// Set the argument to the instance.
as_boxno = is_boxno

// Return true
return true
end function

public function boolean f_getlocation (ref string as_location);// Set the argument to the instance.
as_location = is_location

// Return true
return true
end function

public function boolean f_getstatus (ref string as_status);// Set the argument to the instance.
as_status = is_status

// Return true
return true
end function

on nvo_dcmcleared.create
call super::create
end on

on nvo_dcmcleared.destroy
call super::destroy
end on

