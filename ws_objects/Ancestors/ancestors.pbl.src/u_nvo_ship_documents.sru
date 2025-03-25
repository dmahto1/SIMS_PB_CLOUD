$PBExportHeader$u_nvo_ship_documents.sru
$PBExportComments$Generic driver for printing shipment documents
forward
global type u_nvo_ship_documents from nonvisualobject
end type
end forward

global type u_nvo_ship_documents from nonvisualobject
end type
global u_nvo_ship_documents u_nvo_ship_documents

forward prototypes
public function integer wf_load_documents (ref datawindow adw_shipdocs)
public function integer wf_print (ref datawindow adw_shipdocs)
end prototypes

public function integer wf_load_documents (ref datawindow adw_shipdocs);
Return 0
end function

public function integer wf_print (ref datawindow adw_shipdocs);
Return 0
end function

on u_nvo_ship_documents.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_ship_documents.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

