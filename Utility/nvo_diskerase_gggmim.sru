HA$PBExportHeader$nvo_diskerase_gggmim.sru
forward
global type nvo_diskerase_gggmim from nvo
end type
end forward

global type nvo_diskerase_gggmim from nvo
end type
global nvo_diskerase_gggmim nvo_diskerase_gggmim

type variables
Private string is_boxnumber, is_googlepartnumber, is_manpartnumber, is_driveserialnumber, is_source, is_filename
Private date idt_boxcreationdate, idt_importdate
Private boolean ib_locked, ib_existing
end variables

forward prototypes
public function boolean f_setboxnumber (string as_boxno)
public function boolean f_setgooglepartnumber (string as_googlepartno)
public function boolean f_setmanpartnumber (string as_manpartno)
public function boolean f_setdriveserialnumber (string as_driveserialno)
public function boolean f_setlocked (boolean ab_locked)
public function boolean f_setboxcreationdate (date adt_boxcreationdate)
public function boolean f_getboxnumber (ref string as_boxno)
public function boolean f_getgooglepartnumber (ref string as_googlepartno)
public function boolean f_getmanpartnumber (ref string as_manpartno)
public function boolean f_getdriveserialnumber (ref string as_driveserialno)
public function boolean f_getlocked (ref boolean ab_locked)
public function boolean f_getboxcreationdate (ref date adt_boxcreationdate)
public function boolean f_reset ()
public function boolean f_setimportdate (date adt_importdate)
public function boolean f_setfilename (string as_filename)
public function boolean f_setsource (string as_source)
public function boolean f_getsource (ref string as_source)
public function boolean f_getfilename (ref string as_filename)
public function boolean f_getimportdate (ref date adt_importdate)
public function boolean f_insertupdate ()
public function boolean f_retrieve ()
public function boolean f_alreadyexists ()
end prototypes

public function boolean f_setboxnumber (string as_boxno);// Set the instance to the argument.
is_boxnumber = as_boxno

// Return true
return true
end function

public function boolean f_setgooglepartnumber (string as_googlepartno);// Set the instance to the argument.
is_googlepartnumber = as_googlepartno

// Return true
return true
end function

public function boolean f_setmanpartnumber (string as_manpartno);// Set the instance to the argument.
is_manpartnumber = as_manpartno

// Return true
return true
end function

public function boolean f_setdriveserialnumber (string as_driveserialno);// Set the instance to the argument.
is_driveserialnumber = as_driveserialno

// Return true
return true
end function

public function boolean f_setlocked (boolean ab_locked);// Set the instance to the argument.
ib_locked = ab_locked

// Return true
return true
end function

public function boolean f_setboxcreationdate (date adt_boxcreationdate);// Set the instance to the argument.
idt_boxcreationdate = adt_boxcreationdate

// Return true
return true
end function

public function boolean f_getboxnumber (ref string as_boxno);// Set the instance to the argument.
as_boxno = is_boxnumber

// Return true
return true
end function

public function boolean f_getgooglepartnumber (ref string as_googlepartno);// Set the instance to the argument.
as_googlepartno = is_googlepartnumber

// Return true
return true
end function

public function boolean f_getmanpartnumber (ref string as_manpartno);// Set the instance to the argument.
as_manpartno = is_manpartnumber

// Return true
return true
end function

public function boolean f_getdriveserialnumber (ref string as_driveserialno);// Set the instance to the argument.
as_driveserialno = is_driveserialnumber

// Return true
return true
end function

public function boolean f_getlocked (ref boolean ab_locked);// Set the instance to the argument.
ab_locked = ib_locked

// Return true
return true
end function

public function boolean f_getboxcreationdate (ref date adt_boxcreationdate);// Set the instance to the argument.
adt_boxcreationdate = idt_boxcreationdate

// Return true
return true
end function

public function boolean f_reset ();// Reset all object variables.
is_boxnumber = ""
is_googlepartnumber = ""
is_manpartnumber = ""
is_driveserialnumber = ""
is_source = ""
is_filename = ""
idt_boxcreationdate = date('1/1/1900')
idt_importdate =  date('1/1/1900')
ib_locked = false

// Return true
return true
end function

public function boolean f_setimportdate (date adt_importdate);// Set the instance to the argument.
idt_importdate = adt_importdate

// Return true
return true	
end function

public function boolean f_setfilename (string as_filename);// Set the instance to the argument.
is_filename = as_filename

// Reutn true
return true
end function

public function boolean f_setsource (string as_source);// Set the instance to the argument.
is_source = as_source

// Return true
return true
end function

public function boolean f_getsource (ref string as_source);// Set the argument to the instance.
as_source = is_source

// Return true
return true
end function

public function boolean f_getfilename (ref string as_filename);// Set the argument to the instance.
as_filename = is_filename

// Return true
return true
end function

public function boolean f_getimportdate (ref date adt_importdate);// Set the argument to the instance.
adt_importdate = idt_importdate

// Return true
return true
end function

public function boolean f_insertupdate ();// If this record already existed,
if f_alreadyexists() then
	
	// Update the record,
	update diskerase set filename = :is_filename, source = :is_source, partno = :is_googlepartnumber, manpartno = :is_manpartnumber, creationdate = :idt_boxcreationdate, importdate = :idt_importdate where boxno = :is_boxnumber and driveserialno = :is_driveserialnumber using sqlca;
	
// Otherwise, if this is a new record,
Else
	
	// Insert the new record.
	insert into diskerase values (:is_filename, :is_source, :is_boxnumber, :is_googlepartnumber, :is_manpartnumber, :is_driveserialnumber, :idt_boxcreationdate, :idt_importdate) using sqlca;
	
// End  if this is a new record.
End If

// Return sqlca.sqlcode = 0
return sqlca.sqlcode = 0
end function

public function boolean f_retrieve ();string ls_filename, ls_source, ls_manpartno, ls_partno, ls_boxno, ls_driveserial
date ldt_creationdate, ldt_importdate

// See if the record already exists.
f_getboxnumber(ls_boxno)
f_getdriveserialnumber(ls_driveserial)

// Get the object.
select filename, source, partno, manpartno, creationdate, importdate 
into :ls_filename, :ls_source, :ls_partno, :ls_manpartno, :ldt_creationdate, :ldt_importdate
from diskerase 
where boxno = :ls_boxno and driveserialno = :ls_driveserial using sqlca;
	
// If we got a record,
If sqlca.sqlcode = 0 then
	
	is_boxnumber = ls_boxno
	is_googlepartnumber = ls_manpartno
	is_manpartnumber = ls_manpartno
	is_driveserialnumber = ls_driveserial
	is_source = ls_source
	is_filename = ls_filename
	idt_boxcreationdate = ldt_creationdate
	idt_importdate = ldt_importdate
	
	// Set the existing flag.
	ib_existing = true
	
End If

// Return true
return ib_existing
end function

public function boolean f_alreadyexists ();string ls_boxno, ls_driveserial
long ll_numrecs
date ldt_creationdate, ldt_importdate

// See if the record already exists.
f_getboxnumber(ls_boxno)
f_getdriveserialnumber(ls_driveserial)

// Get the object.
select count(*)
into :ll_numrecs
from diskerase 
where boxno = :ls_boxno and driveserialno = :ls_driveserial using sqlca;
	
// If we got a record,
If ll_numrecs > 0 then
	
	// Set the existing flag.
	ib_existing = true
	
End If

// Return true
return ib_existing
end function

on nvo_diskerase_gggmim.create
call super::create
end on

on nvo_diskerase_gggmim.destroy
call super::destroy
end on

