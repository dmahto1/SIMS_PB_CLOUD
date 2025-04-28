HA$PBExportHeader$u_sqlutil.sru
$PBExportComments$sql utilities
forward
global type u_sqlutil from nonvisualobject
end type
end forward

global type u_sqlutil from nonvisualobject
end type
global u_sqlutil u_sqlutil

type variables
constant integer success = 1
constant integer failure = -1

string isTitle

private:
long		ilEndBlock
string 	isOriginalSQL

string isSelect
long   ilSelectEndPos

string isFrom
string isWhere
string isGroupBy
string isHaving
string isOrderBy

end variables

forward prototypes
public function string getorderby ()
public subroutine setoriginalsql (string assql)
public function string getoriginalsql ()
public function integer doparsesql ()
public subroutine setorderby (string assql)
public subroutine setselect (string assql)
public subroutine setfrom (string assql)
public subroutine setwhere (string assql)
public subroutine setgroupby (string assql)
public subroutine sethaving (string assql)
public function string getselect ()
public function string getfrom ()
public function string getwhere ()
public function string getgroupby ()
public function string gethaving ()
public subroutine settitle (string astitle)
public function string gettitle ()
public subroutine setendblock (long avalue)
public function long getendblock ()
public subroutine setselectendpos (long avalue)
public function long getselectendpos ()
public subroutine doresetsql ()
public subroutine setnewwhere (string aswhere)
public function string getsql ()
public function string dofindblock (string asblock)
public function string dofindblock (string asstartblock, string asblock)
public function integer createwherefromdw (ref datawindow _dw)
public function boolean doblockexistcheck (string asblock)
public function string getnextendblock (string startblock)
public function string docolumnstrip (string ascol)
end prototypes

public function string getorderby ();// string = getOrderby()
return isOrderBy

end function

public subroutine setoriginalsql (string assql);// setOriginalSql( string asSql )
isOriginalSql =  Trim ( asSql  )


end subroutine

public function string getoriginalsql ();// string = getOriginalSQL()
return  isOriginalSQL

end function

public function integer doparsesql ();// int = doParseSQL()

string returnValue
string lsOriginalSql
string lsWorkerant
long alength
string endblock
string startblock

if IsNull( getOriginalSql() ) or Len( trim( getOriginalSql() ) ) = 0 then
	messagebox( GetTitle(), "Original Sql not Set or Missing.", exclamation! )
	return failure
end if

lsOriginalSql = getOriginalSql() 

setOriginalSql( getOriginalSql() )

// Get the Select Block
setSelect( doFindBlock( 'SELECT', 'FROM'  ) )
alength = len( getSelect() )
if alength = 0 then
	messagebox( GetTitle(), "Select Statement Invalid, Please Check!", exclamation! )
	return failure
end if
lsWorkerAnt = Trim( right( getOriginalSQL(), len( getOriginalSQL() ) - alength ) )
setOriginalSQL(  lsWorkerAnt  )

// set the from clause
endblock = getNextEndBlock('FROM' )
if endblock = '' then
	setFrom( lsWorkerAnt )
	setOriginalSQL( lsOriginalSql )
	return success  // that's all there is
else
	setFrom( doFindBlock('FROM', endblock  ) )
	alength = len( getFrom() )
	lsWorkerAnt = Trim( right( getOriginalSQL(), len( getOriginalSQL() ) - alength ) )
	setOriginalSQL( lsWorkerAnt  )
end if

// do the rest of it
startblock = endblock
do while len( endblock ) > 0
	endblock = getNextEndBlock( startblock )
	if endblock = '' then
		choose case startblock
			case 'WHERE'
				setWhere(  Trim(  lsWorkerAnt ) )
			case 'ORDER BY'
				setOrderBy( Trim(  lsWorkerAnt ) )
			case 'GROUP BY'
				setGroupBy(  Trim(  lsWorkerAnt ) )
			case 'HAVING'
				setHaving(  Trim(  lsWorkerAnt ) )
		end choose
		continue // that's all there is
	else
		choose case startblock
			case 'WHERE'
				setWhere(  doFindBlock( startblock, endblock ) )
				alength = len( getWhere() )
			case 'ORDER BY'
				setOrderBy( doFindBlock( startblock, endblock ) )
				alength = len( getOrderBy() )
			case 'GROUP BY'
				setGroupBy(  doFindBlock( startblock, endblock ) )
				alength = len( getGroupBy() )
			case 'HAVING'
				setHaving(  doFindBlock( startblock, endblock ) )
				alength = len( getHaving() )
		end choose
		lsWorkerAnt = Trim( right( getOriginalSQL(), len( getOriginalSQL() ) - alength ) )
		setOriginalSQL(   lsWorkerAnt  )
		startblock = endblock
	end if
loop

// return the original sql to where it belongs
setOriginalSQL( lsOriginalSql )

return success

end function

public subroutine setorderby (string assql);// setOrderBy( string asSql )
isOrderBy = asSql


end subroutine

public subroutine setselect (string assql);// setSelect( string asSql )
isSelect = asSql


end subroutine

public subroutine setfrom (string assql);// setFrom( string asSql )
isFrom = asSql


end subroutine

public subroutine setwhere (string assql);// setWhere( string asSql )
isWhere = asSql


end subroutine

public subroutine setgroupby (string assql);// setGroupBy( string asSql )
isGroupBy = asSql


end subroutine

public subroutine sethaving (string assql);// setHaving( string asSql )
isHaving = asSql


end subroutine

public function string getselect ();// string = getSelect()
return isSelect


end function

public function string getfrom ();// string = getFrom()
return isFrom

end function

public function string getwhere ();// string = getWhere()
return isWhere


end function

public function string getgroupby ();// string = getGroupBy()
return isGroupBy

end function

public function string gethaving ();// string = getHaving()
return isHaving

end function

public subroutine settitle (string astitle);// setTitle( string asTitle )
isTitle = asTitle

end subroutine

public function string gettitle ();// string = getTitle()

if isNull( isTitle ) or len( trim( isTitle ) ) = 0 then
	return 'Sql Utility'
else
	return isTitle
end if

end function

public subroutine setendblock (long avalue);// setEndBlock( long avalue )
ilEndBlock = avalue

end subroutine

public function long getendblock ();// long = getEndBlock()
return ilEndBlock

end function

public subroutine setselectendpos (long avalue);// SetSelectEndPos( long avalue )
ilSelectEndPos = avalue

end subroutine

public function long getselectendpos ();// long = getSelectEndPos()
return ilSelectEndPos
end function

public subroutine doresetsql ();// doResetSql()

doParseSql( )


end subroutine

public subroutine setnewwhere (string aswhere);// setNewWhere( string asWhere )

string workerAnt
string newWhere
string test, test2

asWhere =  Trim(asWhere)

test = Upper( left( asWhere, 5 ) )
test2 = getWhere()

// strip of the WHERE keyword on incoming clauses.
if Upper( left( asWhere, 5 ) ) = 'WHERE' then asWhere = right( asWhere, ( len( asWhere) - 6 ))
if len( getWhere() ) = 0 then
	workerAnt = ' WHERE '
else
	workerAnt = getWhere() + ' AND '
end if
newWhere = workerAnt + asWhere
setWhere( newWhere )

end subroutine

public function string getsql ();// string = getSQL()

string asSql

asSql = getSelect() + getFrom() + getWhere()

if len( getGroupBy() ) > 0 then	asSql += getGroupBy()
if len( getHaving() ) > 0 then asSql += getHaving()
if len( getOrderBy() ) > 0 then asSql += getOrderBy() 

return asSql

	

end function

public function string dofindblock (string asblock);// string = FindBlock( string asBlock )

long liPos
string ReturnBlock
string test

ReturnBlock = ''

liPos = pos( getOriginalSql(), asBlock, 1 )
if liPos > 0 then	ReturnBlock = mid( getOriginalSql(), 1, len( getOriginalSql() )  )

return Trim( ReturnBlock )



end function

public function string dofindblock (string asstartblock, string asblock);// string = FindBlock( string asStartBlock, string asBlock )

// find the block designated by startblock and ending as asBlock
long liBeginBlock
long liStartBlockBegin
long liEndBlock
long liSqlLength
long liPos
string ReturnBlock

liSqlLength = len( getOriginalSql()  )

liPos = -1
liBeginBlock = 1
do until liPos = 0
	 liPos = pos( getOriginalSql(),  asBlock, liBeginBlock )
	 if liPos > 0  then
		liEndBlock = liPos
		liBeginBlock = ( liPos + 1)
	end if
loop
liEndBlock --

if liEndBlock < 0 then return '' // End Keyword not found

setEndBlock( liEndBlock )

ReturnBlock = mid( getOriginalSql(), liStartBlockBegin, liEndBlock )

return Trim( ReturnBlock )



end function

public function integer createwherefromdw (ref datawindow _dw);// integer = CreateWhereFromDW( ref datawindow _dw )
//
// pass in  a reference to a datawindow and this function
// will create a where clause based on the values in the columns
// and do a setWhere() with it.
//

int index
int max
int cntr
string colName
string colDBName
string colValue
string colTag
string whereExpression[]
string beginwhere
string sAnd = ' and '
string sOperator
string sEqual = " =~'" 
string sEGT = " >=~'" 
string sELT = " <=~'" 

_dw.accepttext()

max = Integer( _dw.Object.DataWindow.Column.Count )
for index = 1 to max
	colName = _dw.describe( "#" + string( index ) + ".Name" )
	colDBName = _dw.describe( colname + ".dbName" )
	sOperator = sEqual
	colTag = _dw.describe( colname + ".Tag" )
	if colTag = 'from' then
		sOperator = sEGT
		colDBName = doColumnStrip(colDBName)
	end if	
	if colTag = 'to' then
		sOperator = sELT
		colDBName = doColumnStrip(colDBName)
	end if
	
	if _dw.describe( colName + ".visible" ) = '0' then continue
	choose case Lower( left( _dw.describe( colName + ".ColType" ), 5) )
		case "char("
			colValue = _dw.getItemString( _dw.getrow(), colName  ) 
			if lower( colValue ) = 'all' then continue
			if IsNull( colValue) or len( colValue) = 0 then continue
			cntr ++
			whereExpression[ cntr ] = colDBName + sOperator + colvalue + "~'"
		case "date$$HEX1$$b700$$ENDHEX$$"
			colValue = String( _dw.getItemDate( _dw.getrow(), colName  ) )
			if IsNull( colValue) or len( colValue) = 0 then continue
			if  colValue = '00/00/0000' or colValue='01/01/1900' then continue
			cntr ++
			whereExpression[ cntr ] = colDBName + sOperator + colvalue + "~'"
		case "datet"
			colValue = String( _dw.getItemDateTime( _dw.getrow(), colName  ) )
			if IsNull( colValue) or len( colValue) = 0 then continue
			if left( colValue, 10 ) = '00/00/0000' or colValue='01/01/1900 00:00:00' then continue
			cntr ++
			whereExpression[ cntr ] = colDBName + sOperator + colvalue + "~'"
		case "decim", "int     " , "long " , "numbe", "real ", "ulong"
			colValue = String( _dw.getItemNumber( _dw.getrow(), colName  ) )
			if IsNull( colValue) or len( colValue) = 0 then continue
			cntr ++
			whereExpression[ cntr ] = colDBName + sOperator + colvalue + "~'"
		case "time ", "times"
			colValue = String( _dw.getItemTime( _dw.getrow(), colName  ) )
			if IsNull( colValue) or len( colValue) = 0 then continue
			cntr ++
			whereExpression[ cntr ] = colDBName + sOperator + colvalue + "~'"
	end choose
next
max = UpperBound( whereExpression )
beginWhere = ''
for index = 1 to max
	beginWhere += whereExpression[ index ] + sAnd
next
if len( beginWhere ) > 0 then 
	beginWhere = left( beginwhere, ( len( beginWhere) - len( sAnd )) ) + " "
	setNewWhere( beginWhere )
end if

return success

end function

public function boolean doblockexistcheck (string asblock);// boolean = doBlockExistCheck( string asBlock )

if pos( getOriginalSql(), asBlock, 1 ) > 0 then	return true
return false




end function

public function string getnextendblock (string startblock);// string = getNextEndBlock()
string isSQL
int ilPos
int offset
string returnValue
isSQL = getOriginalSql()

ilPos = Pos( isSQL, Upper( startblock ) )
if ilPos > 0 then offset = len( startBlock ) +1

returnValue = ''
if pos( getOriginalSql(), 'WHERE' , offset ) > 0 then
	returnValue =  'WHERE'
elseif pos( getOriginalSql(), 'GROUP BY' , offset ) > 0 then
	returnValue =  'GROUP BY'
elseif pos( getOriginalSql(), 'HAVING' , offset ) > 0 then
	returnValue =  'HAVING'
elseif pos( getOriginalSql(), 'ORDER BY' , offset ) > 0 then
	returnValue =  'ORDER BY'
end if
return returnValue

end function

public function string docolumnstrip (string ascol);// string = doColumnStrip( string asCol )

string lsTableName
string lsColumn
int ipos

ipos = pos( asCol, "." )
lsTableName = left( asCol, ipos )
lsColumn = right( asCol, ( (len( asCol ) - ( ipos +1) )  ) )

return lsTableName +  lsColumn

end function

on u_sqlutil.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_sqlutil.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*
pvh 09/22/05 - Created

This doesn't work for union, union all and other multi sql selects....YET! :)

Use:

declare an instance of this object

	u_sqlutil lsqlutil

Instantiate this object

	lsqlutil = Create lsqlutil

call setOriginalSql( string asSql )

	lsqlutil.setOriginalSql( whatever sql you want parsed )
	
call doParseSql()

The sql will parsed and available through the following methods....

getSelect()
getWhere()
getFrom()
getGroupBy()
getOrderBy()
getHaving()

Use the associated sets to modify the sql.

To build a sql statement with the modified where call...

NewSql = getSql()

To reset the parsed sql to the original sql call...

doResetSQL()

Note:  

	if using sql with inbedded selects like the below example, 
	make sure the inbedded sql is in lowercase or the call to
	doParseSql() will not function as expected
	
	SELECT dbo.Location.L_Code,   
			dbo.Location.SKU_Reserved,
			( select max( dbo.delivery_master.complete_date ) 
			from dbo.delivery_master,   
					 dbo.delivery_picking  
			where ( dbo.delivery_picking.do_no = dbo.delivery_master.do_no ) and  
						( dbo.delivery_master.project_id = dbo.project_warehouse.project_id ) and  
						  dbo.delivery_picking.sku = dbo.location.sku_reserved   ) as "last_pick_date"  ,
			dbo.Location.SKU_Reserved,
			dbo.Project_Warehouse.Project_ID,
			dbo.Location.WH_Code,
			'          ' as 'NumberOfDaysEmpty'
   FROM dbo.Location,   
                dbo.Project_Warehouse  
   WHERE ( dbo.Location.WH_Code = dbo.Project_Warehouse.WH_Code ) and  
          	    ( dbo.Location.SKU_Reserved is not null ) AND  
         		    ( len( rtrim(ltrim(dbo.Location.SKU_Reserved))) > 0 ) and
         		   ( dbo.Location.SKU_Reserved not in (  select dbo.content.sku  
                  		                               							from dbo.content  
                        			                       							 where dbo.content.project_id = dbo.project_warehouse.project_id  and
																		dbo.content.wh_code = dbo.project_warehouse.wh_code ) )   and
				dbo.Project_Warehouse.Project_ID = '*project*' 

	ORDER BY dbo.Location.L_Code ASC   
	
*/

end event

