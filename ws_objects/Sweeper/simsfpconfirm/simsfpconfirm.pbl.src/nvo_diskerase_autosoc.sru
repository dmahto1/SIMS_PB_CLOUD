$PBExportHeader$nvo_diskerase_autosoc.sru
forward
global type nvo_diskerase_autosoc from nvo
end type
end forward

global type nvo_diskerase_autosoc from nvo
end type
global nvo_diskerase_autosoc nvo_diskerase_autosoc

type variables
// Object originally designed by KZUV.COM

protected string is_boxno
protected string is_driveserialno
end variables

forward prototypes
public function boolean f_setboxno (string as_boxno)
public function boolean f_setdriveserialno (string as_driveserialno)
public function boolean f_getboxno (ref string as_boxno)
public function boolean f_getdriveserialno (ref string as_driveserialno)
end prototypes

public function boolean f_setboxno (string as_boxno);// Set the instance to the argument.
is_boxno = as_boxno

// Return true
return true
end function

public function boolean f_setdriveserialno (string as_driveserialno);// Set the instance to the argument.
as_driveserialno = as_driveserialno

// Return true
return true
end function

public function boolean f_getboxno (ref string as_boxno);// Set the argument to the instance.
as_boxno = is_boxno

// Return true
return true
end function

public function boolean f_getdriveserialno (ref string as_driveserialno);// Set the argument to the instance.
as_driveserialno = as_driveserialno

// Return true
return true
end function

on nvo_diskerase_autosoc.create
call super::create
end on

on nvo_diskerase_autosoc.destroy
call super::destroy
end on

