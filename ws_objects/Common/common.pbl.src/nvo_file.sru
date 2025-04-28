$PBExportHeader$nvo_file.sru
forward
global type nvo_file from nvo
end type
end forward

global type nvo_file from nvo
end type
global nvo_file nvo_file

type variables
PUBLIC PRIVATEWRITE String is_path, is_folder, is_filename
PUBLIC PRIVATEWRITE Boolean ib_set
PRIVATE OLEObject obj_shell
end variables

forward prototypes
public function boolean is_blank (string as_test)
public function boolean of_set_file (string as_path)
public function datetime of_get_creation_datetime ()
public function date of_get_creation_date ()
public function date of_get_modified_date ()
end prototypes

public function boolean is_blank (string as_test);//Created by TimA 07/23/15

IF IsNull( as_test ) THEN RETURN TRUE
IF as_test = '' THEN RETURN TRUE

RETURN FALSE
end function

public function boolean of_set_file (string as_path);//Created by TimA 07/23/15

IF FileExists( as_path ) THEN
  is_path = as_path
  is_folder = Left( is_path, LastPos( is_path, '\' ) )
  is_filename = Mid( is_path, LastPos( is_path, '\' ) + 1 )
  ib_set = TRUE
ELSE
  is_path = ''
  is_folder = ''
  is_filename = ''
  ib_set = FALSE
END IF

RETURN ib_set

end function

public function datetime of_get_creation_datetime ();//Created by TimA 07/23/15

String ls_datetime, ls_time
DateTime ldt_file
Date ld_date
OLEObject obj_folder, obj_item

//first off, make sure the path is set to a valid file...
IF ib_set THEN
  obj_folder = obj_shell.NameSpace( is_folder ) //folder
  obj_item = obj_folder.ParseName( is_filename ) //file

  ls_datetime = obj_folder.GetDetailsOf( obj_item, 4 )
  //the date can be ripped directly out of the string
  ld_date = Date( ls_datetime )
  //time cannot be ripped directly out of the string
  //a blank space is the separator from the date & time
  ls_time = Mid( ls_datetime, Pos( ls_datetime, ' ' ) + 1 )
  
  //combine the two...
  ldt_file = DateTime( ld_date, Time( ls_time ) )
END IF

//clear up memory
DESTROY obj_folder
DESTROY obj_item

RETURN ldt_file
end function

public function date of_get_creation_date ();//Created by TimA 07/23/15

String ls_datetime, ls_time
DateTime ldt_file
Date ld_date
OLEObject obj_folder, obj_item

//first off, make sure the path is set to a valid file...
IF ib_set THEN
  obj_folder = obj_shell.NameSpace( is_folder ) //folder
  obj_item = obj_folder.ParseName( is_filename ) //file

  ls_datetime = obj_folder.GetDetailsOf( obj_item, 4 ) //This is last create date
  
  //the date can be ripped directly out of the string
  ld_date = Date( ls_datetime )
  
END IF

//clear up memory
DESTROY obj_folder
DESTROY obj_item

RETURN ld_date
end function

public function date of_get_modified_date ();//Created by TimA 09/1/15

String ls_datetime, ls_time
DateTime ldt_file
Date ld_date
OLEObject obj_folder, obj_item

//first off, make sure the path is set to a valid file...
IF ib_set THEN
  obj_folder = obj_shell.NameSpace( is_folder ) //folder
  obj_item = obj_folder.ParseName( is_filename ) //file

  ls_datetime = obj_folder.GetDetailsOf( obj_item, 3 ) //This is last modified date
  //the date can be ripped directly out of the string
  ld_date = Date( ls_datetime )
  
END IF

//clear up memory
DESTROY obj_folder
DESTROY obj_item

RETURN ld_date
end function

on nvo_file.create
call super::create
end on

on nvo_file.destroy
call super::destroy
end on

event constructor;call super::constructor;//Created by TimA 07/23/15

obj_shell = CREATE OLEObject
obj_shell.ConnectToNewObject( 'shell.application' )
end event

event destructor;call super::destructor;//Created by TimA 07/23/15

DESTROY obj_shell
end event

