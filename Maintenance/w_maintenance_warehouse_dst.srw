HA$PBExportHeader$w_maintenance_warehouse_dst.srw
$PBExportComments$- warehouse modify
forward
global type w_maintenance_warehouse_dst from w_response_ancestor
end type
type tab_1 from tab within w_maintenance_warehouse_dst
end type
type tabpage_2 from userobject within tab_1
end type
type st_daylight_savings_time_begin_in from statictext within tabpage_2
end type
type ddlb_end_year from dropdownlistbox within tabpage_2
end type
type ddlb_begin_year from dropdownlistbox within tabpage_2
end type
type ddlb_end_months from dropdownlistbox within tabpage_2
end type
type st_daylight_savings_time_end_of from statictext within tabpage_2
end type
type ddlb_end_days from dropdownlistbox within tabpage_2
end type
type ddlb_end_occurs from dropdownlistbox within tabpage_2
end type
type st_daylight_savings_time_end from statictext within tabpage_2
end type
type st_daylight_savings_time_begin_of from statictext within tabpage_2
end type
type ddlb_begin_months from dropdownlistbox within tabpage_2
end type
type ddlb_begin_days from dropdownlistbox within tabpage_2
end type
type ddlb_begin_occurs from dropdownlistbox within tabpage_2
end type
type st_daylight_savings_time_begin from statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
st_daylight_savings_time_begin_in st_daylight_savings_time_begin_in
ddlb_end_year ddlb_end_year
ddlb_begin_year ddlb_begin_year
ddlb_end_months ddlb_end_months
st_daylight_savings_time_end_of st_daylight_savings_time_end_of
ddlb_end_days ddlb_end_days
ddlb_end_occurs ddlb_end_occurs
st_daylight_savings_time_end st_daylight_savings_time_end
st_daylight_savings_time_begin_of st_daylight_savings_time_begin_of
ddlb_begin_months ddlb_begin_months
ddlb_begin_days ddlb_begin_days
ddlb_begin_occurs ddlb_begin_occurs
st_daylight_savings_time_begin st_daylight_savings_time_begin
end type
type tab_1 from tab within w_maintenance_warehouse_dst
tabpage_2 tabpage_2
end type
type st_daylight_savings_time_end_in from statictext within w_maintenance_warehouse_dst
end type
type cb_warehouse_dst_clear from commandbutton within w_maintenance_warehouse_dst
end type
type cb_warehouse_dst_ok from commandbutton within w_maintenance_warehouse_dst
end type
type cb_warehouse_dst_cancel from commandbutton within w_maintenance_warehouse_dst
end type
end forward

global type w_maintenance_warehouse_dst from w_response_ancestor
integer width = 3154
integer height = 792
string title = "Daylight Savings Time Edit"
event ue_ok ( )
event ue_clear ( )
tab_1 tab_1
st_daylight_savings_time_end_in st_daylight_savings_time_end_in
cb_warehouse_dst_clear cb_warehouse_dst_clear
cb_warehouse_dst_ok cb_warehouse_dst_ok
cb_warehouse_dst_cancel cb_warehouse_dst_cancel
end type
global w_maintenance_warehouse_dst w_maintenance_warehouse_dst

type variables
datetime dstStart
datetime dstEnd

integer  iicalctype
constant integer iicalcspecific = 1
constant integer iicalcrelative = 2
constant integer success = 0
constant integer failure = -1


string isStartCode
string isEndCode
string isCode




end variables

forward prototypes
public subroutine setdststart (datetime _value)
public subroutine setdstend (datetime _value)
public function datetime getdststart ()
public function datetime getdstend ()
public function integer getcalctype ()
public subroutine setparms (str_parms _strparms)
public function str_parms getparms ()
public function integer setrelativedates ()
public function datetime getrelativedatefor (ref dropdownlistbox _occurs, ref dropdownlistbox _daylist, ref dropdownlistbox _monthlist, ref dropdownlistbox _year)
public subroutine setdstrelcode (string _value)
public subroutine setstartcode (string _value)
public subroutine setendcode (string _value)
public subroutine setcode (string _value)
public function string getcode ()
public function string getstartcode ()
public function string getendcode ()
end prototypes

event ue_ok();// ue_ok

if setRelativeDates() = failure then return

closewithreturn( this, istrparms )

end event

event ue_clear();// ue_clear
istrparms.string_arg[1] = 'CLEAR'
closewithreturn( this, istrparms )


end event

public subroutine setdststart (datetime _value);// setdststart( datetime _value )

dstStart = _value

end subroutine

public subroutine setdstend (datetime _value);// setdstend( datetime _value )

dstend = _value

end subroutine

public function datetime getdststart ();// datetime = getdststart()
return dststart

end function

public function datetime getdstend ();// datetime = getdstend()
return dstEnd


end function

public function integer getcalctype ();// integer = getCalcType()
return iiCalcType

end function

public subroutine setparms (str_parms _strparms);// setParms( str_parms _strParms )

istrparms = _strParms

end subroutine

public function str_parms getparms ();// str_parms = getparms()
return istrparms

end function

public function integer setrelativedates ();// integer = setRelativeDates()

datetime startdate
datetime enddate
boolean errorflag

String lsStartoccurance 
String lsStartDay 		
String lsStartMonth 	
String lsEndoccurance 
String lsEndDay 		
String lsEndMonth 	

if len( tab_1.tabpage_2.ddlb_begin_occurs.text ) = 0 then return failure
if len( tab_1.tabpage_2.ddlb_begin_days.text )  = 0 then return failure
if len( tab_1.tabpage_2.ddlb_begin_months .text )  = 0 then return failure
if len(tab_1.tabpage_2.ddlb_end_occurs.text )  = 0 then return failure
if len( tab_1.tabpage_2.ddlb_end_days.text )  = 0 then return failure
if len( tab_1.tabpage_2.ddlb_end_months .text )  = 0 then return failure
if len(tab_1.tabpage_2.ddlb_begin_year.text )  = 0 then return failure
if len(tab_1.tabpage_2.ddlb_end_year.text )  = 0 then return failure


// pass the code used back to the warehouse maint to store it

IstrParms.datetime_arg[1] = getrelativedatefor( tab_1.tabpage_2.ddlb_begin_occurs, &
																	tab_1.tabpage_2.ddlb_begin_days, &
																	tab_1.tabpage_2.ddlb_begin_months, &
																	tab_1.tabpage_2.ddlb_begin_year )

setStartCode( getCode() )

IstrParms.datetime_arg[2] = getrelativedatefor( tab_1.tabpage_2.ddlb_end_occurs, &
																	tab_1.tabpage_2.ddlb_end_days, &
																	tab_1.tabpage_2.ddlb_end_months, &
																	tab_1.tabpage_2.ddlb_end_year )
																	
																	
setEndCode( getCode() )
IstrParms.String_arg[1] = getstartcode()+"*"+getEndCode()

return success

end function

public function datetime getrelativedatefor (ref dropdownlistbox _occurs, ref dropdownlistbox _daylist, ref dropdownlistbox _monthlist, ref dropdownlistbox _year);// datetime = getrelativedatefor( dropdownlistbox _occurs, dropdownlistbox _daylist,dropdownlistbox _monthlist, dropdownlistbox _year )

string soccurance
string sDay
string sMonth
date adate
date datearray[]
int occurs
int day
int month
int workermonth
int cntr
int year
int index

string lsZeros = '00'
time atime = 00:00:00

soccurance = _occurs.text
sDay = _daylist.text
sMonth = _monthlist.text

occurs = _occurs.FindItem ( soccurance, 0 )
day = _daylist.FindItem ( sDay, 0 )
month = _monthlist.FindItem ( sMonth, 0 )
year = integer( _year.text )

workermonth = month
cntr=1
adate = date( string(month) + "/" + string(cntr) + "/" + string(year) )
do while workermonth = month
	if dayNumber( adate ) = day then 
		index ++
		datearray[ index ] = adate
	end if
	cntr++
	adate = date( string(month) + "/" + string(cntr) + "/" + string(year) )
	if adate = date("1900-01-01") then workermonth++
loop

if occurs > index then occurs = index
adate = datearray[ occurs ]

setCode( string(occurs) + string(day) + right( lsZeros + string(month), 2) )

return datetime( adate, atime )

end function

public subroutine setdstrelcode (string _value);// setDSTRelCode( string _value )

// value comes in 1101*1112
//
// The four characters on the left represent the start indexes, 1 = first, 1=Sunday, 01= January
// The four characters on the right are the end representation
//
string startcode
string endcode
int startoccur
int startdaynumber
int startmonth
int endoccur
int enddaynumber
int endmonth
int lpos

lpos = (pos(  _value , "*" ) -1 )

startcode = left( _value, lpos  )
endcode = right( _value,4)

startoccur			= Integer( left( startcode,1) )
startdaynumber 	= Integer( mid( startcode, 2,1 ) )
startmonth			= Integer( right( startcode,2) )
endoccur			= Integer( left( endcode,1) )
enddaynumber	= Integer( mid( endcode, 2,1 ) )
endmonth			= Integer( right( endcode,2) )

tab_1.tabpage_2.ddlb_begin_occurs.SelectItem ( startoccur ) 
tab_1.tabpage_2.ddlb_begin_days.SelectItem ( startdaynumber )	
tab_1.tabpage_2.ddlb_begin_months .SelectItem ( startmonth ) 
tab_1.tabpage_2.ddlb_end_year.SelectItem ( 1 ) 

tab_1.tabpage_2.ddlb_end_occurs.SelectItem ( endoccur )
tab_1.tabpage_2.ddlb_end_days.SelectItem ( enddaynumber )	
tab_1.tabpage_2.ddlb_end_months .SelectItem ( endmonth )
	tab_1.tabpage_2.ddlb_begin_year.SelectItem ( 1 ) 


end subroutine

public subroutine setstartcode (string _value);// setStartCode( string _value )
isStartCode = _value

end subroutine

public subroutine setendcode (string _value);// setEndCode( string _value )
isEndCode = _value

end subroutine

public subroutine setcode (string _value);// setCode( string _value )
isCode = _value

end subroutine

public function string getcode ();// string = getCode()
return isCode

end function

public function string getstartcode ();// string = getStartCode()
return isStartCode

end function

public function string getendcode ();// string = getEndCode()
return isEndCode

end function

on w_maintenance_warehouse_dst.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.st_daylight_savings_time_end_in=create st_daylight_savings_time_end_in
this.cb_warehouse_dst_clear=create cb_warehouse_dst_clear
this.cb_warehouse_dst_ok=create cb_warehouse_dst_ok
this.cb_warehouse_dst_cancel=create cb_warehouse_dst_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.st_daylight_savings_time_end_in
this.Control[iCurrent+3]=this.cb_warehouse_dst_clear
this.Control[iCurrent+4]=this.cb_warehouse_dst_ok
this.Control[iCurrent+5]=this.cb_warehouse_dst_cancel
end on

on w_maintenance_warehouse_dst.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.st_daylight_savings_time_end_in)
destroy(this.cb_warehouse_dst_clear)
destroy(this.cb_warehouse_dst_ok)
destroy(this.cb_warehouse_dst_cancel)
end on

event ue_postopen;call super::ue_postopen;string ayear
int iyear
int index

IstrParms = message.powerobjectparm

iyear= year( today() )

ayear = string( iyear )
tab_1.tabpage_2.ddlb_begin_year.AddItem( ayear)
tab_1.tabpage_2.ddlb_end_year.AddItem( ayear)
for index = 1 to 4
	iyear++
	tab_1.tabpage_2.ddlb_end_year.AddItem( string( iyear ) )
	tab_1.tabpage_2.ddlb_begin_year.AddItem( string( iyear ) )
next

if len( IstrParms.string_arg[1]  ) > 0 then
	setDstRelCode( IstrParms.string_arg[1]  )
end if

Istrparms.Cancelled = false
end event

event ue_cancel;Istrparms.Cancelled = True
Closewithreturn(This,Istrparms)
end event

event ue_close;Closewithreturn(This,Istrparms)

end event

event close;call super::close;Closewithreturn(This,Istrparms)
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_maintenance_warehouse_dst
integer x = 1874
integer y = 1020
integer taborder = 40
end type

type cb_ok from w_response_ancestor`cb_ok within w_maintenance_warehouse_dst
boolean visible = false
integer x = 1184
integer y = 828
integer taborder = 20
end type

event cb_ok::clicked;parent.event ue_ok()
end event

type tab_1 from tab within w_maintenance_warehouse_dst
integer y = 28
integer width = 3118
integer height = 480
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_2)
end on

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3081
integer height = 352
long backcolor = 79741120
string text = "Relative Date"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_daylight_savings_time_begin_in st_daylight_savings_time_begin_in
ddlb_end_year ddlb_end_year
ddlb_begin_year ddlb_begin_year
ddlb_end_months ddlb_end_months
st_daylight_savings_time_end_of st_daylight_savings_time_end_of
ddlb_end_days ddlb_end_days
ddlb_end_occurs ddlb_end_occurs
st_daylight_savings_time_end st_daylight_savings_time_end
st_daylight_savings_time_begin_of st_daylight_savings_time_begin_of
ddlb_begin_months ddlb_begin_months
ddlb_begin_days ddlb_begin_days
ddlb_begin_occurs ddlb_begin_occurs
st_daylight_savings_time_begin st_daylight_savings_time_begin
end type

on tabpage_2.create
this.st_daylight_savings_time_begin_in=create st_daylight_savings_time_begin_in
this.ddlb_end_year=create ddlb_end_year
this.ddlb_begin_year=create ddlb_begin_year
this.ddlb_end_months=create ddlb_end_months
this.st_daylight_savings_time_end_of=create st_daylight_savings_time_end_of
this.ddlb_end_days=create ddlb_end_days
this.ddlb_end_occurs=create ddlb_end_occurs
this.st_daylight_savings_time_end=create st_daylight_savings_time_end
this.st_daylight_savings_time_begin_of=create st_daylight_savings_time_begin_of
this.ddlb_begin_months=create ddlb_begin_months
this.ddlb_begin_days=create ddlb_begin_days
this.ddlb_begin_occurs=create ddlb_begin_occurs
this.st_daylight_savings_time_begin=create st_daylight_savings_time_begin
this.Control[]={this.st_daylight_savings_time_begin_in,&
this.ddlb_end_year,&
this.ddlb_begin_year,&
this.ddlb_end_months,&
this.st_daylight_savings_time_end_of,&
this.ddlb_end_days,&
this.ddlb_end_occurs,&
this.st_daylight_savings_time_end,&
this.st_daylight_savings_time_begin_of,&
this.ddlb_begin_months,&
this.ddlb_begin_days,&
this.ddlb_begin_occurs,&
this.st_daylight_savings_time_begin}
end on

on tabpage_2.destroy
destroy(this.st_daylight_savings_time_begin_in)
destroy(this.ddlb_end_year)
destroy(this.ddlb_begin_year)
destroy(this.ddlb_end_months)
destroy(this.st_daylight_savings_time_end_of)
destroy(this.ddlb_end_days)
destroy(this.ddlb_end_occurs)
destroy(this.st_daylight_savings_time_end)
destroy(this.st_daylight_savings_time_begin_of)
destroy(this.ddlb_begin_months)
destroy(this.ddlb_begin_days)
destroy(this.ddlb_begin_occurs)
destroy(this.st_daylight_savings_time_begin)
end on

type st_daylight_savings_time_begin_in from statictext within tabpage_2
integer x = 2505
integer y = 84
integer width = 137
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "in"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;g.of_check_label_button(this)
end event

type ddlb_end_year from dropdownlistbox within tabpage_2
integer x = 2651
integer y = 220
integer width = 411
integer height = 628
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_begin_year from dropdownlistbox within tabpage_2
integer x = 2651
integer y = 64
integer width = 411
integer height = 460
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_end_months from dropdownlistbox within tabpage_2
integer x = 2080
integer y = 220
integer width = 430
integer height = 1100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = false
boolean sorted = false
string item[] = {"January","February","March","April","May","June","July","August","September","October","November","December"}
borderstyle borderstyle = stylelowered!
end type

type st_daylight_savings_time_end_of from statictext within tabpage_2
integer x = 1911
integer y = 236
integer width = 155
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "of"
boolean focusrectangle = false
end type

event constructor;g.of_check_label_button(this)
end event

type ddlb_end_days from dropdownlistbox within tabpage_2
integer x = 1472
integer y = 220
integer width = 430
integer height = 896
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = false
boolean sorted = false
string item[] = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_end_occurs from dropdownlistbox within tabpage_2
integer x = 1120
integer y = 220
integer width = 343
integer height = 532
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = false
boolean sorted = false
string item[] = {"First","Second","Third","Fourth","Last"}
borderstyle borderstyle = stylelowered!
end type

type st_daylight_savings_time_end from statictext within tabpage_2
integer x = 46
integer y = 232
integer width = 1065
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Daylight Savings Time Ends on the "
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;g.of_check_label_button(this)
end event

type st_daylight_savings_time_begin_of from statictext within tabpage_2
integer x = 1911
integer y = 80
integer width = 155
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "of"
boolean focusrectangle = false
end type

event constructor;g.of_check_label_button(this)
end event

type ddlb_begin_months from dropdownlistbox within tabpage_2
integer x = 2080
integer y = 64
integer width = 430
integer height = 1100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = false
boolean sorted = false
string item[] = {"January","February","March","April","May","June","July","August","September","October","November","December"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_begin_days from dropdownlistbox within tabpage_2
integer x = 1472
integer y = 64
integer width = 430
integer height = 896
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = false
boolean sorted = false
string item[] = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_begin_occurs from dropdownlistbox within tabpage_2
integer x = 1125
integer y = 64
integer width = 343
integer height = 600
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = false
boolean sorted = false
string item[] = {"First","Second","Third","Fourth","Last"}
borderstyle borderstyle = stylelowered!
end type

type st_daylight_savings_time_begin from statictext within tabpage_2
integer x = 9
integer y = 80
integer width = 1106
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Daylight Savings Time Begins on the "
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;g.of_check_label_button(this)
end event

type st_daylight_savings_time_end_in from statictext within w_maintenance_warehouse_dst
integer x = 2528
integer y = 376
integer width = 137
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "in"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;g.of_check_label_button(this)
end event

type cb_warehouse_dst_clear from commandbutton within w_maintenance_warehouse_dst
integer x = 1362
integer y = 556
integer width = 270
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;parent.event ue_clear()

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_warehouse_dst_ok from commandbutton within w_maintenance_warehouse_dst
integer x = 837
integer y = 556
integer width = 270
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;
parent.TriggerEvent("ue_close")
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_warehouse_dst_cancel from commandbutton within w_maintenance_warehouse_dst
integer x = 1874
integer y = 556
integer width = 270
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;
parent.TriggerEvent("ue_cancel")
end event

event constructor;
g.of_check_label_button(this)
end event

