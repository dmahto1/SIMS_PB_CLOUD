$PBExportHeader$w_phxbrands_mthly_inbnd_ctn_count_rpt.srw
forward
global type w_phxbrands_mthly_inbnd_ctn_count_rpt from w_std_report
end type
end forward

global type w_phxbrands_mthly_inbnd_ctn_count_rpt from w_std_report
string title = "PHXBRANDS Monthly Inbound Carton Count"
end type
global w_phxbrands_mthly_inbnd_ctn_count_rpt w_phxbrands_mthly_inbnd_ctn_count_rpt

type variables
string isWarehouse
string isWhcode

int		iiYear
int		iiMonth

date idBeginDate
date idEndDate

string theDateRange

end variables

forward prototypes
public subroutine setmonth (integer amonth)
public function integer getmonth ()
public subroutine setyear (integer ayear)
public function integer getyear ()
public subroutine setwarehouse (string aswarehouse)
public function string getwarehouse ()
public subroutine setreportdates ()
public subroutine setbegindate (date adate)
public subroutine setenddate (date adate)
public function date getbegindate ()
public function date getenddate ()
public function integer getlastdayofmonth (integer amonth, integer ayear)
public subroutine dofilterwarehouse ()
public function boolean dovalidate ()
public subroutine setreportdata ()
public subroutine setthedaterange (string therange)
public function string getthedaterange ()
public subroutine setdisplaywarehouse ()
public subroutine setwhcode (string _value)
public function string getwhcode ()
end prototypes

public subroutine setmonth (integer amonth);// setMonth( int aMonth )
iiMonth = aMonth

end subroutine

public function integer getmonth ();// int = getMonth()
return iiMonth

end function

public subroutine setyear (integer ayear);// setYear( int aYear )
iiYear = aYear


end subroutine

public function integer getyear ();// int = getYear()
return iiYear

end function

public subroutine setwarehouse (string aswarehouse);// setWarehouse( string asWarehouse )
isWarehouse = asWarehouse
end subroutine

public function string getwarehouse ();// string = getwarehouse()
return isWarehouse

end function

public subroutine setreportdates ();// setReportDate()

// Transform the entered month and year into begin/end dates for the retrieval

string sBegin
string sEnd
string sSlash = "/"
string sdayone = '01'
string sdayend 

date begindate
date enddate

sDayEnd = string( getLastDayOfMonth( getMonth(), getYear() ) )

sBegin =  String( getMonth() ) + sSlash + sdayone + sSlash + string( getYear() )
sEnd    =  String( getMonth() ) + sSlash + sdayend + sSlash + string( getYear() ) 

setTheDateRange( sBegin + ' - ' + sEnd )

setBegindate( date( sbegin ) )
setEndDate ( date( sEnd ) )





end subroutine

public subroutine setbegindate (date adate);// setBeginDate( date adate )
idBeginDate = adate

end subroutine

public subroutine setenddate (date adate);// setEndDate( date adate )
idendDate = adate

end subroutine

public function date getbegindate ();// date = GetBeginDate()
return idBeginDate

end function

public function date getenddate ();// date = GetEndDate()
return idendDate

end function

public function integer getlastdayofmonth (integer amonth, integer ayear);// integer = getLastDayOfMonth( integer aMonth, integer aYear )

integer returnValue

returnValue = 1

choose case aMonth
	case 1,3,5,7,8,10,12
		returnValue = 31
	case 4,6,9,11
		returnValue = 30
	case 2
		if mod( aYear, 4 ) = 0 then
			returnValue = 29
		else
			returnValue = 28
		end if
end choose

return returnValue

end function

public subroutine dofilterwarehouse ();// DoFilterWarehouse()

// Filter the report by warehouse.

string sBegin = 'wh_code = ~''
string sEnd = '~''
string sFilter

dw_report.setfilter("")
dw_report.filter()

if getwarehouse() = 'all' then return

sFilter = sBegin + getWarehouse() + sEnd
dw_report.setfilter( sFilter )
dw_report.filter()


end subroutine

public function boolean dovalidate ();// boolean = dovalidate()
long theRow

dw_select.acceptText()

theRow = dw_select.getRow()

if isNull( dw_select.object.warehouse[ theRow ]  ) or len( String( dw_select.object.warehouse[ theRow ]) ) = 0 then
	setWarehouse( 'all')
	dw_select.object.warehouse[ theRow ] = getWarehouse()
end if

if isNull(   dw_select.object.report_month[ theRow ]  ) or  Integer( dw_select.object.report_month[ theRow ] ) = 0 then
	beep(1)
	messagebox( this.title, "Please select a MONTH and Re-Try.", exclamation! )
	return false
end if

if isNull(  dw_select.object.report_year[ theRow ]  ) or &
	Not IsNumber(dw_select.object.report_year[ theRow ] ) or &
	Integer( dw_select.object.report_year[ theRow ] )  = 0 then
	beep(1)
	messagebox( this.title, "Please Enter a Year and Re-Try.", exclamation! )
	return false
end if

return true

end function

public subroutine setreportdata ();// setReportData()

long theRow

dw_select.accepttext()

theRow = dw_select.getRow()

string test
test = dw_select.object.warehouse[ theRow ]

setWarehouse( dw_select.object.warehouse[ theRow ]  )
setMonth(  Integer( dw_select.object.report_month[ theRow ] ) )
setYear(  Integer( dw_select.object.report_year[ theRow ] )  )

end subroutine

public subroutine setthedaterange (string therange);theDateRange = theRange
end subroutine

public function string getthedaterange ();return theDateRange

end function

public subroutine setdisplaywarehouse ();int index
int rows

rows = dw_report.rowCount()

for index = 1 to rows
	dw_report.object.wh_code[ index ] = 'All'
next

end subroutine

public subroutine setwhcode (string _value);isWhCode = _value

end subroutine

public function string getwhcode ();return isWhCode

end function

on w_phxbrands_mthly_inbnd_ctn_count_rpt.create
call super::create
end on

on w_phxbrands_mthly_inbnd_ctn_count_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_postopen;call super::ue_postopen;datawindowchild adwc
long childrow

// Initialize

setPointer( hourglass! )

this.setredraw( false )

// add 'All' to selection dropdown

dw_select.getchild("warehouse",adwc )
adwc.settransobject( sqlca )
adwc.retrieve( gs_project )
childrow = adwc.insertrow(0)
adwc.setitem( childrow, "wh_name"   , "-- ALL --" )
adwc.setitem( childrow, "wh_code"   , "all" )
adwc.setsort( "warehouse A")
adwc.sort()

setWarehouse( 'all' ) // setdefault
dw_select.object.report_year[ dw_select.getrow() ] = string( year( today() ) )

this.setredraw( true )
end event

event ue_retrieve;call super::ue_retrieve;
if Not doValidate() then return

setPointer( Hourglass! )

setReportData()

dw_report.setredraw( false )

dw_report.reset()

setReportDates()

if dw_report.retrieve( getBeginDate(), getEndDate() ) < 0 then
	messagebox( this.title,"There was an Error Retrieving Report Data,~r~n" + &
									"Please Contact Support.",exclamation!)
	return
end if

DoFilterWarehouse()

if dw_report.rowcount() = 0 then 
		messagebox( this.title,"No Data Found!!!",exclamation!)
end if
dw_report.groupcalc()

dw_report.setredraw( true )


end event

event resize;call super::resize;dw_report.event ue_resize()


end event

event ue_clear;call super::ue_clear;dw_select.setredraw( false )
dw_select.reset()
dw_select.insertrow(0)
dw_select.setredraw( true )
end event

type dw_select from w_std_report`dw_select within w_phxbrands_mthly_inbnd_ctn_count_rpt
event ue_accepttext ( )
integer width = 3305
string dataobject = "d_phxbrands_mthly_inbnd_ctn_count_select"
end type

event dw_select::ue_accepttext();this.accepttext()

end event

type cb_clear from w_std_report`cb_clear within w_phxbrands_mthly_inbnd_ctn_count_rpt
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_phxbrands_mthly_inbnd_ctn_count_rpt
event ue_resize ( )
integer taborder = 30
string dataobject = "d_phxbrands_mthly_inbound_ctn_count_rpt"
end type

event dw_report::ue_resize();
this.width = (parent.width - 50)
this.height = ( parent.height - ( dw_select.height + 192 ) )

end event

