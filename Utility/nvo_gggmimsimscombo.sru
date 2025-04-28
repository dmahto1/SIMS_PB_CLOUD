HA$PBExportHeader$nvo_gggmimsimscombo.sru
forward
global type nvo_gggmimsimscombo from nvo
end type
end forward

global type nvo_gggmimsimscombo from nvo
end type
global nvo_gggmimsimscombo nvo_gggmimsimscombo

type variables
Private string is_boxno, is_googleboxno, is_drivepartno, is_driveserialno, is_location
Private datetime idt_stockdatetime
end variables

forward prototypes
public function boolean f_setboxno (string as_boxno)
public function boolean f_setgoogleboxno (string as_googleboxno)
public function boolean f_setdrivepartno (string as_drivepartno)
public function boolean f_setdriveserialno (string as_driveserialno)
public function boolean f_setlocation (string as_location)
public function boolean f_getboxno (ref string as_boxno)
public function boolean f_getgoogleboxno (ref string as_googleboxno)
public function boolean f_getdrivepartno (ref string as_drivepartno)
public function boolean f_getdriveserialno (ref string as_driveserialno)
public function boolean f_getlocation (ref string as_location)
public function boolean f_setstockdatetime (datetime adt_stockdatetime)
public function boolean f_getstockdatetime (ref datetime adt_stockdatetime)
end prototypes

public function boolean f_setboxno (string as_boxno);// Set the instance to the argument.
is_boxno = as_boxno

// Return true
return true
end function

public function boolean f_setgoogleboxno (string as_googleboxno);// Set the argument to the instance.
is_googleboxno = as_googleboxno

// Return true
return true
end function

public function boolean f_setdrivepartno (string as_drivepartno);// Set the argument to the instance.
is_drivepartno = as_drivepartno

// Return true
return true
end function

public function boolean f_setdriveserialno (string as_driveserialno);// Set the argument to the instance.
is_driveserialno = as_driveserialno

// Return true
return true
end function

public function boolean f_setlocation (string as_location);// Set the argument to the instance.
is_location = as_location

// Return true
return true
end function

public function boolean f_getboxno (ref string as_boxno);// Set the argument to the instance.
as_boxno = is_boxno

// Return true
return true
end function

public function boolean f_getgoogleboxno (ref string as_googleboxno);// Set the argument to the instance.
as_googleboxno = is_googleboxno

// Return true
return true
end function

public function boolean f_getdrivepartno (ref string as_drivepartno);// Set the argument to the instance.
as_drivepartno = is_drivepartno

// Return true
return true
end function

public function boolean f_getdriveserialno (ref string as_driveserialno);// Set the argument to the instance.
as_driveserialno = is_driveserialno

// Return true
return true
end function

public function boolean f_getlocation (ref string as_location);// Set the argument to the instance.
as_location = is_location

// Return true
return true
end function

public function boolean f_setstockdatetime (datetime adt_stockdatetime);// Set the argument to the instance.
idt_stockdatetime = adt_stockdatetime

// Return true
return true
end function

public function boolean f_getstockdatetime (ref datetime adt_stockdatetime);// Set the argument to the instance.
adt_stockdatetime = idt_stockdatetime

// Return true
return true
end function

on nvo_gggmimsimscombo.create
call super::create
end on

on nvo_gggmimsimscombo.destroy
call super::destroy
end on

