HA$PBExportHeader$w_color_codes.srw
forward
global type w_color_codes from w_response_ancestor
end type
type dw_1 from datawindow within w_color_codes
end type
type st_1 from statictext within w_color_codes
end type
end forward

global type w_color_codes from w_response_ancestor
integer width = 4000
integer height = 2000
string title = "Color Codes"
boolean minbox = true
boolean resizable = true
windowtype windowtype = popup!
event ue_add ( )
event ue_delete ( )
event ue_print ( )
event type integer ue_save ( )
event ue_setvcrmoved ( long avalue )
event ue_resequence ( )
event ue_preopen ( )
dw_1 dw_1
st_1 st_1
end type
global w_color_codes w_color_codes

type variables
//constant string isDetailNoteType = 'OD'
//constant string isOrderNoteType = 'OC'
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

decimal idlineItemNumbers[]

long ilNewRow

uo_vcr vcr

end variables

forward prototypes
public subroutine setproject (string asvalue)
public subroutine setdono (string asvalue)
public function string getproject ()
public function string getdono ()
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
end prototypes

event ue_add();// ue_add

//long newrow
//
//newrow = dw_1.insertrow( 0)
//dw_1.scrolltorow( newrow )
//dw_1.setrow( newrow )
//setNewRow( newRow )
//


end event

event ue_delete();// ue_delete

//long aRow
//
//aRow = dw_1.getrow()
//if aRow <=0 then
//	messagebox( this.title, "Please select a note to delete, then re-try." , exclamation! )
//	return
//end if
//
//if messagebox( this.title, "Are you sure you want to delete this note?",question!,yesno!) <> 1 then return
//
//dw_1.deleteRow( arow )
//
//this.event ue_resequence()
//
//return
//

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

event ue_preopen;Long ll_TurnOnResize
ll_TurnOnResize = This.of_SetResize(True)

//inv_resize.of_SetMinSize( 1500, (cb_clear.Height + 30) * 3)

//inv_resize.of_SetMinSize( cbx_batchmode.X + cb_clear.Width *3 + 145,   mle_history.Y + cb_clear.Height *3 + 90)

 //This.inv_resize.of_Register(dw_select, this.inv_resize.SCALEBOTTOM)
If ll_TurnOnResize = 1 then

//This.width = 3000
//this.height = 1700
This.inv_resize.of_SetMinSize( 2500 ,  1732 )	

	//Main Header and datawindow
//	This.inv_resize.of_Register(st_Main_header_t, this.inv_resize.SCALERIGHT)
	This.inv_resize.of_Register(dw_1, this.inv_resize.SCALE)
//	//This.inv_resize.of_Register(cb_do_search, this.inv_resize.SCALE)
	
	//Comand buttons
	This.inv_resize.of_Register(cb_ok, this.inv_resize.SCALE)

end if	
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

public subroutine setdatawindow ();// setDatawindow(  )

dw_1.settransobject( sqlca )

end subroutine

public subroutine settitle ();// setTitle()

This.title = getBaseTitle() 
//This.title = getBaseTitle() + " For Order: " + getOrderNumber()
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

on w_color_codes.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
end on

on w_color_codes.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.st_1)
end on

event open;istrParms = message.powerobjectparm

setProject( istrparms.String_Arg[1] )
//setDoNo( istrParms.String_Arg[2] )
//setOrderNumber( istrParms.String_arg[3] )

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

event ue_retrieve;call super::ue_retrieve;//dw_1.retrieve( getProject(), getDoNo() )
dw_1.retrieve( getProject())

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_color_codes
boolean visible = false
integer x = 2496
integer y = 1472
end type

type cb_ok from w_response_ancestor`cb_ok within w_color_codes
integer x = 3621
integer y = 1644
boolean default = false
end type

type dw_1 from datawindow within w_color_codes
integer x = 9
integer y = 184
integer width = 3899
integer height = 1396
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_color_codes"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_color_codes
integer x = 9
integer y = 20
integer width = 3909
integer height = 136
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SIMS Color codes"
alignment alignment = center!
boolean focusrectangle = false
end type

