$PBExportHeader$u_nvo_dst_setdates.sru
forward
global type u_nvo_dst_setdates from nonvisualobject
end type
end forward

global type u_nvo_dst_setdates from nonvisualobject
end type
global u_nvo_dst_setdates u_nvo_dst_setdates

type variables
constant integer success = 1
constant integer failure = -1
constant integer noAction = 0

datastore idsDSTWarehouses
datastore idsDSTTableLookup

Private:
	int iiYear
	datetime idtBeginDate
	datetime idtEndDate
	

end variables

forward prototypes
public function integer setdates ()
public subroutine setyear (integer _value)
public function integer getyear ()
public subroutine setbegindate (datetime _value)
public subroutine setenddate (datetime _value)
public function datetime getbegindate ()
public function datetime getenddate ()
public function integer dorelativecalc (string _code)
public function datetime doparsecode (string _code)
public function integer doupdatewarehouse ()
public function integer setdstbywarehousedate (long _index)
end prototypes

public function integer setdates ();// integer = setdates()
//
// retrieve the participating warehoueses....warehouse dst flag is set to 'Y'
//
// if an entry exists in table_lookup then it is used to calculate the relative date dst begins and ends.
// if the table_lookup entry does not exist, then the dst start and end dates are populated using the current year.
// 
// functionality exists to pass in a year and do the calculations, call setYear( int ayear ) prior to making the call to here.  The constructor sets the 
// year to the current year.
//
int dstWarehouseRows
int lookuptableRow

long index
string sProject
string sWarehouse
string sWarehouseCode

// load the participating warehouses
dstWarehouseRows = idsDSTWarehouses.retrieve()
if dstWarehouseRows <= 0 then return NoAction

// process them
index = 1
Do while index <= dstWarehouseRows
	sProject 				= idsDSTWarehouses.object.project_id[ index ]
	sWarehouseCode 	= idsDSTWarehouses.object.wh_code[ index ]
	lookuptableRow 	= idsDSTTableLookup.retrieve( sProject, sWarehouseCode )
	if lookuptableRow > 0 then
		doRelativeCalc( idsDSTTableLookup.object.code_descript[ lookuptableRow ] ) 
	else
		setDSTByWarehouseDate( index )
	end if
	idsDSTWarehouses.object.dst_start[ index ] = getBeginDate()
	idsDSTWarehouses.object.dst_end[ index ] = getEndDate()
	index++
Loop

// update the warehouse table and return
Execute Immediate "Begin Transaction" using SQLCA; 
if idsDSTWarehouses.update() <> 1 then
	Execute Immediate "ROLLBACK" using SQLCA;
	return failure
else
	Execute Immediate "COMMIT" using SQLCA;
	return success
end if

end function

public subroutine setyear (integer _value);// setYear( int _value )

if isNull( _value ) then return
if _value <=0 then return
if len( string( _value ) ) = 2 then _value = 2000 + _value  // if this is still being used in the 22nd millenium, then my appoligies. I'm dead and don't care.

iiYear = _value


end subroutine

public function integer getyear ();// int = getYear()
return iiYear

end function

public subroutine setbegindate (datetime _value);// setBeginDate( datetime _value )

idtBeginDate = _value

end subroutine

public subroutine setenddate (datetime _value);// setEndDate( datetime _value )

idtEndDate = _value

end subroutine

public function datetime getbegindate ();// datetime = getBeginDate()
return idtBeginDate

end function

public function datetime getenddate ();// datetime = getEndDate()
return idtEndDate

end function

public function integer dorelativecalc (string _code);// int doRelativeCale( string _code )
//
// code = 1101*1101 where the left side = begin date and right side is end date in the following format...
//
// 1101 = first, Sunday, January
// 5712 = last, Saturday, December
//
string sBegin
string sEnd
datetime dtDate

sBegin = left( _code, 4 )
sEnd = right( _code, 4 )
setBeginDate( doParseCode( sBegin ) )
setEndDate( doParseCode( sEnd ) )

return success



end function

public function datetime doparsecode (string _code);// datetime = doParseCode( string _code )
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

occurs 	= Integer( left( _code, 1 ) )
Day 		= Integer( mid( _code, 2,1) )
Month 	= Integer( right( _code,2) )
year 		= getYear()

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

return datetime( adate, atime )

end function

public function integer doupdatewarehouse ();// doUpdateWarehouse()

// set the values into the warehouse datastore and update


return success



end function

public function integer setdstbywarehousedate (long _index);// integer = setDSTByWarehouseDate( long _index )

int aday
int amonth
string slash = "/"
datetime startDate
datetime endDate
int aYear

startDate = idsDSTWarehouses.object.dst_start[ _index ]
endDate = idsDSTWarehouses.object.dst_end[ _index ]
aYear = getYear()

aday = day( date(startDate) )
amonth = month ( date(startDate) )
startDate = datetime( date( string( amonth ) + slash + string( aday ) + slash + string( aYear) ) , time( '00:00:00') )
setBeginDate( startDate )

aday = day( date(endDate) )
amonth = month ( date(endDate) )
endDate = datetime( date( string( amonth ) + slash + string( aday ) + slash + string( aYear) ) , time( '00:00:00') )
setEndDate( endDate )

return success

end function

on u_nvo_dst_setdates.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_dst_setdates.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
idsDSTWarehouses 	= f_datastorefactory("d_dst_participating_warehouses")
idsDSTTableLookup	= f_datastorefactory("d_dst_warehousetablelookup")

// set the default year to this year
setYear( year( today() ))



end event

