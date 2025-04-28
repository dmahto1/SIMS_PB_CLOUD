$PBExportHeader$w_order_details.srw
forward
global type w_order_details from w_response_ancestor
end type
type dw_1 from datawindow within w_order_details
end type
end forward

global type w_order_details from w_response_ancestor
integer width = 3762
integer height = 1572
string title = "Order Details"
boolean controlmenu = false
windowtype windowtype = popup!
event ue_add ( )
event ue_delete ( )
event ue_print ( )
event type integer ue_save ( )
event ue_setvcrmoved ( long avalue )
event ue_resequence ( )
dw_1 dw_1
end type
global w_order_details w_order_details

type variables
constant string isDetailNoteType = 'OD'
constant string isOrderNoteType = 'OC'
constant integer success = 1
constant integer failure = -1
constant boolean no = false
constant boolean yes = true

boolean ibDisplayVCR

string isProject
string isDoNo
string isNoteType
integer ilLineItemNumber
string isBaseTitle
string isOrderNumber
String isDatawindowName

decimal idlineItemNumbers[]

long ilNewRow

uo_vcr vcr

end variables

forward prototypes
public subroutine setproject (string asvalue)
public subroutine setdono (string asvalue)
public function string getproject ()
public function string getdono ()
public subroutine setnotetype (string asvalue)
public function string getnotetype ()
public function string getdetailnotetype ()
public function string getordernotetype ()
public subroutine setdatawindow ()
public subroutine settitle ()
public subroutine setnewrow (long newrow)
public function long getnewrow ()
public function boolean docheckforchanges ()
public function integer doaccepttext ()
public function integer dovalidate ()
public subroutine setvcrdisplay ()
public function boolean getdisplayvcr ()
public subroutine setdisplayvcr (boolean avalue)
public subroutine setlineitemnumber (integer avalue)
public function integer getlineitemnumber ()
public subroutine setbasetitle (string atitle)
public function string getbasetitle ()
public subroutine setordernumber (string avalue)
public function string getordernumber ()
public subroutine setdatawindowname (string avalue)
end prototypes

event ue_add();// ue_add

long newrow

newrow = dw_1.insertrow( 0)
dw_1.scrolltorow( newrow )
dw_1.setrow( newrow )
setNewRow( newRow )



end event

event ue_delete();// ue_delete

long aRow

aRow = dw_1.getrow()
if aRow <=0 then
	messagebox( this.title, "Please select a note to delete, then re-try." , exclamation! )
	return
end if

if messagebox( this.title, "Are you sure you want to delete this note?",question!,yesno!) <> 1 then return

dw_1.deleteRow( arow )

this.event ue_resequence()

return


end event

event ue_print();// ue_print

end event

event type integer ue_save();// ue_save()

//if doAcceptText() < 0 then
//	messagebox( this.title, "Save Failed! Contact Technical Support!", exclamation! )
//	return failure
//end if
//
//if doValidate() <> success then return failure
//
//if dw_1.update() <> 1 then
//	messagebox( this.title, "Save Failed! Contact Technical Support!", exclamation! )
//	Execute Immediate "ROLLBACK" using SQLCA;
//	return failure
//else
//	Execute Immediate "COMMIT" using SQLCA;
//end if

return success


end event

event ue_setvcrmoved(long avalue);// ue_setvcrmoved( long avalue )

//setCurrentRow( avalue )

end event

event ue_resequence();// ue_resequence()

end event

public subroutine setproject (string asvalue);// setProject( string asValue )
isProject = asvalue

end subroutine

public subroutine setdono (string asvalue);// setDoNo( string asValue )
isDoNo = asvalue

end subroutine

public function string getproject ();// string = getProject()
return isProject

end function

public function string getdono ();// string = getDoNo()
return isDoNo

end function

public subroutine setnotetype (string asvalue);// setNoteType( string asValue )
isNoteType = asvalue

end subroutine

public function string getnotetype ();// string = getNoteType()
return isNoteType


end function

public function string getdetailnotetype ();// string = getDetailNoteType()
return isDetailNoteType

end function

public function string getordernotetype ();// string = getOrderNoteType()
return isOrderNoteType

end function

public subroutine setdatawindow ();
dw_1.settransobject( sqlca )

end subroutine

public subroutine settitle ();// setTitle()

This.title = getBaseTitle() + " For Order: " + getOrderNumber()
end subroutine

public subroutine setnewrow (long newrow);// setNewRow( long newrow )
ilNewRow = newrow

end subroutine

public function long getnewrow ();// long = getNewRow()

if IsNull( ilNewRow) then ilNewRow = 0

return ilNewRow

end function

public function boolean docheckforchanges ();// boolean = doCheckForChanges()

if dw_1.getNextModified( 0, Primary! ) > 0 then return true
if dw_1.deletedcount() > 0 then return true

return false



end function

public function integer doaccepttext ();return dw_1.accepttext()

end function

public function integer dovalidate ();// integer = doValidate()
return success


end function

public subroutine setvcrdisplay ();// setVcrDisplay()
str_parms lstrParms

if NOT getDisplayVCR() then return

if Not isValid( vcr ) then
	lstrParms.long_arg[ 1 ] = 1
	lstrParms.long_arg[ 2 ] = 1
	lstrParms.long_arg[ 3 ] = 1
 	openUserObjectwithparm( vcr, lstrParms,965, 1008 )
end if

end subroutine

public function boolean getdisplayvcr ();// getDisplayVCR()
return ibDisplayVCR

end function

public subroutine setdisplayvcr (boolean avalue);// setdisplayVCR( boolean avalue )
ibDisplayVCR = avalue
//
end subroutine

public subroutine setlineitemnumber (integer avalue);// setLineItemNumber( integer avalue )
ilLineItemNumber = avalue

end subroutine

public function integer getlineitemnumber ();// integer = getLineItemNumber()
return ilLineItemNumber
end function

public subroutine setbasetitle (string atitle);// setBaseTitle( string atitle )
isBaseTitle = atitle

end subroutine

public function string getbasetitle ();// string = getBaseTitle()
return isBaseTitle

end function

public subroutine setordernumber (string avalue);// setOrderNumber( string avalue )
isOrderNumber = avalue

end subroutine

public function string getordernumber ();// string = getOrderNumber()
return isOrderNumber

end function

public subroutine setdatawindowname (string avalue);
isDatawindowName = avalue

end subroutine

on w_order_details.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_order_details.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;istrParms = message.powerobjectparm

setProject( istrparms.String_Arg[1] )
setDoNo( istrParms.String_Arg[2] )
setOrderNumber( istrParms.String_Arg[3] )
setDataWindowName( istrParms.String_arg[4] )

// setDatawindow(  )
Choose case Upper(isDatawindowName)
	Case 'W_RO' 
		dw_1.Dataobject = 'd_ro_detail_extras'
	Case Upper ( 'W_DO' )
		dw_1.Dataobject = 'd_do_detail_extras'
End choose

setDisplayVCR( no )

setBaseTitle( this.title )

super:: event open()

end event

event ue_postopen;call super::ue_postopen;
setDatawindow()

this.event ue_retrieve()

setTitle()

setVCRdisplay()

//dw_1.SetRowFocusIndicator(Hand!)


end event

event ue_close;
if this.event ue_save() = success then close( this )



end event

event ue_cancel;doAcceptText()
if doCheckForChanges() then
	if messagebox( this.title, "Save Changes? ", question!, yesno! ) = 1 then	this.event ue_save() 
end if
Istrparms.Cancelled = True
close( this )


		
end event

event ue_retrieve;call super::ue_retrieve;dw_1.retrieve( getProject(), getDoNo() )

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_order_details
boolean visible = false
integer x = 2496
integer y = 1472
end type

type cb_ok from w_response_ancestor`cb_ok within w_order_details
integer x = 3360
integer y = 1372
string text = "Close"
boolean default = false
end type

type dw_1 from datawindow within w_order_details
integer x = 23
integer y = 24
integer width = 3694
integer height = 1332
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_ro_detail_extras"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

