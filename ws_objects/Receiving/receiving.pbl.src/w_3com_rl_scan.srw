$PBExportHeader$w_3com_rl_scan.srw
forward
global type w_3com_rl_scan from w_response_ancestor
end type
type dw_1 from u_dw within w_3com_rl_scan
end type
type cb_override from commandbutton within w_3com_rl_scan
end type
end forward

global type w_3com_rl_scan from w_response_ancestor
integer width = 2487
integer height = 1760
string title = "3COM RL Scan"
boolean controlmenu = false
long backcolor = 12632256
event ue_ok ( )
event type integer ue_override ( )
dw_1 dw_1
cb_override cb_override
end type
global w_3com_rl_scan w_3com_rl_scan

type variables
datastore idsRL

boolean ibOK

end variables

forward prototypes
public function boolean dovalidate ()
end prototypes

event ue_ok();// ue_ok

if NOT doValidate() then return

dw_1.RowsCopy(1, dw_1.RowCount(), Primary!, idsRL, 1, Primary!)

IstrParms.datastore_arg[1] = idsRL

ibok=true
Closewithreturn(This, istrparms )

end event

event type integer ue_override();int ilResponse

ilResponse = messagebox( this.title,"You have selected to cancel the operation.~r~n~r~n" + &
													"If you continue, any revision levels scanned/entered will be discarded.~r~n~r~nDo you want to continue? ",question!,yesno! )
if ilResponse <> 1 then return -1

Istrparms.Cancelled = True
ibok = true
closewithreturn( this, Istrparms )
return 0





end event

public function boolean dovalidate ();// boolean doValidate()

int index
int max
string rl
string override
boolean founderror
boolean messagedisplayed

max = dw_1.rowcount()

dw_1.accepttext()
founderror = false
messagedisplayed = false
for index = 1 to max
	rl = dw_1.object.rl[index]
	if Trim( Upper( rl ) ) = Trim( Upper( dw_1.object.sku[ index ] )) then continue
	if isNull( rl ) or len( rl ) = 0 then
		if NOT messagedisplayed then
			if messagebox( "3COM RL Scan","Missing data!!~r~nContinue?",question!,yesno! ) <> 1 then
				founderror = true
				exit
			else
				messagedisplayed = true
				continue
			end if
		end if
	end if
	if Match( rl, "[0-9]") then
		founderror = true
		messagebox( "3COM RL Scan","Numeric values found in row " + string ( index ) + "~r~n~r~nNumbers are not allowed.  Please Correct.",stopsign! )
		exit
	end if
	if  Match( rl, "[A-Z][A-Z]" ) then continue
	founderror = true
	messagebox( "3COM RL Scan","Invalid data found in row " + string ( index ) + "~r~n~r~nTwo Letters ( AA-ZZ ) are acceptable.  Please Correct.",stopsign! )
	exit
		
next

if founderror then
	dw_1.scrolltorow( index )
	dw_1.setcolumn( "rl" )
	return false
end if

return true

end function

on w_3com_rl_scan.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_override=create cb_override
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_override
end on

on w_3com_rl_scan.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.cb_override)
end on

event ue_cancel;Istrparms.Cancelled = True
event ue_close()

end event

event ue_postopen;call super::ue_postopen;int max
int index
long insertrow

IstrParms = message.powerobjectparm

max = UpperBound( istrParms.string_arg )
for index = 1 to max
	if len( istrParms.string_arg[ index ] ) > 0 then
		insertrow = dw_1.insertrow(0)
		dw_1.object.sku[ insertrow ] = istrParms.string_arg[ index ]
	end if
next
istrParms.cancelled = false
dw_1.setfocus()

idsRL = f_datastoreFactory( 'd_3com_rl_scan_ext' )

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_3com_rl_scan
boolean visible = false
integer x = 46
integer y = 1328
integer taborder = 0
boolean enabled = false
end type

type cb_ok from w_response_ancestor`cb_ok within w_3com_rl_scan
integer x = 576
integer y = 1552
integer taborder = 20
boolean default = false
end type

event cb_ok::clicked;parent.event ue_ok()

end event

type dw_1 from u_dw within w_3com_rl_scan
event ue_processenter pbm_dwnprocessenter
integer y = 12
integer width = 2441
integer height = 1524
boolean bringtotop = true
string dataobject = "d_3com_rl_scan_ext"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean vscrollbar = true
end type

event ue_processenter;long aRow
aRow = getRow()

if aRow <  rowcount() then
	this.setRow( aRow )
	this.setcolumn( "rl" )
else	
	cb_ok.setfocus()
end if

		
end event

type cb_override from commandbutton within w_3com_rl_scan
integer x = 1719
integer y = 1552
integer width = 325
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;parent.event ue_override(  )

end event

