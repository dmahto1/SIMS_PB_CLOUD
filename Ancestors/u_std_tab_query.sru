HA$PBExportHeader$u_std_tab_query.sru
forward
global type u_std_tab_query from userobject
end type
type cb_retrieve from commandbutton within u_std_tab_query
end type
type dw_report from u_dw within u_std_tab_query
end type
type dw_select from u_dw within u_std_tab_query
end type
type cb_report_reset from commandbutton within u_std_tab_query
end type
end forward

global type u_std_tab_query from userobject
integer width = 3077
integer height = 948
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_reset ( )
event ue_resize ( )
event ue_saveas ( )
event ue_printpreview ( )
event type long ue_sort ( )
cb_retrieve cb_retrieve
dw_report dw_report
dw_select dw_select
cb_report_reset cb_report_reset
end type
global u_std_tab_query u_std_tab_query

type variables
constant integer iidefaultSpace = 25
constant integer success = 1
constant integer failure = -1

boolean ibAddProjectToWhere = false

string isOrigSql
string is_groupby
string is_select
string is_orderby
string isTitle
string isProjectColumn
string isBaseWhere

u_sqlutil SqlUtil
window iwParent

string isfromdatecols[]
string istodatecols[]

end variables

forward prototypes
public subroutine setoriginalsql (string _value)
public function string getoriginalsql ()
public subroutine setgroupby (string _value)
public function string getgroupby ()
public subroutine setselect (string _value)
public function string getselect ()
public subroutine setorderby (string _value)
public function string getorderby ()
public subroutine setcriteriadataobject (string _value)
public subroutine setreportdataobject (string _value)
public function integer dobuildquery ()
public subroutine setparentvalues (ref integer awidth, ref integer aheight)
public subroutine setbasewhere (string _value)
public function string getbasewhere ()
public subroutine settitle (string _value)
public function string gettitle ()
public function datawindow getreport ()
public subroutine doexcelexport ()
public function boolean getaddprojecttowhere ()
public subroutine setaddprojecttowhere (boolean _value)
public subroutine setparentwindow (ref window _value)
public function window getparentwindow ()
public function integer initialize (ref window _parentwindow)
public subroutine doexcelexport (ref datawindow asdw)
public subroutine setfromdatecol (string _column)
public subroutine settodatecol (string _column)
public function boolean isfromdatecolumn (string _column)
public function boolean istodatecolumn (string _column)
public subroutine setdefaultdate (string _column, boolean _from)
public subroutine setprojectcolumnname (string _value)
public function string getprojectcolumnname ()
end prototypes

event ue_reset();int max
int index
datawindow ldw

max = UpperBound( control )
for index = 1 to max
	
	choose case TypeOf( control[ index ] )
		case Datawindow!
			ldw = control[index]
			ldw.reset()
			
		case UserObject!
	end Choose

next
dw_select.insertrow(0)
sqlUtil.setWhere( getBaseWhere() )

end event

event ue_resize();int max
int index
int awidth
int aheight

datawindow ldw
commandbutton btn

setParentValues( awidth, aheight )
this.width = (awidth - iiDefaultSpace)
this.height = ( aheight - (  iiDefaultSpace * 4 ) )

max = UpperBound( control )
for index = 1 to max
	
	choose case TypeOf( control[ index ] )
		case Datawindow!
			ldw = control[index]
			ldw.event dynamic ue_resize()
		case UserObject!
		case commandbutton!
			btn = control[index]
			btn.x = ( ( this.width - iiDefaultSpace )  - btn.width)
	end Choose
	
next

end event

event ue_saveas();// pvh - 11/03/05	

if dw_report.rowcount() <=0 then return

if messagebox( "Save As", "Export to Excel?",question!,yesno!) = 1 then
	doExcelExport(  )
else
	dw_report.Saveas()
end if
	
end event

event ue_printpreview();// ue_print_preview()

if dw_report.rowcount() <=0 then return
OpenwithParm(w_printzoom,dw_report)
end event

event type long ue_sort();// ue_sort()
long ll_ret
String str_null

SetNull(str_null)
IF isvalid(dw_report) THEN
	ll_ret=dw_report.Setsort(str_null)
	ll_ret=dw_report.Sort()
	if isnull(ll_ret) then ll_ret=0
END IF	
return ll_ret

end event

public subroutine setoriginalsql (string _value);// setOriginalSql()
isOrigSql = _value

end subroutine

public function string getoriginalsql ();// string = getOriginalSql()
return isOrigSQL

end function

public subroutine setgroupby (string _value);// setGroupBy()
is_groupby = _value

end subroutine

public function string getgroupby ();// string = getGroupby()
return is_groupby

end function

public subroutine setselect (string _value);// setSelect()
is_select = _value

end subroutine

public function string getselect ();// string = getSelect()
return is_select

end function

public subroutine setorderby (string _value);// setOrderby()
is_orderby = _value

end subroutine

public function string getorderby ();// string = getorderby()
return is_orderby

end function

public subroutine setcriteriadataobject (string _value);// setCriteriaDataObject( string _value )
dw_select.dataobject = _value

end subroutine

public subroutine setreportdataobject (string _value);// setReportDataObject( string _value )
dw_report.dataobject = _value

end subroutine

public function integer dobuildquery ();

return success


end function

public subroutine setparentvalues (ref integer awidth, ref integer aheight);// setParentValues( ref int awidth, ref int aheight )

tab parenttab
window awindow

choose case typeof( getParent() )
	case Tab!
		parentTab = getParent()
		aheight = parentTab.height - iidefaultSpace
		awidth = parentTab.width - iidefaultSpace
	case Window!
		awindow = getParent()
		aheight= awindow.height - iidefaultSpace
		awidth = awindow.width - iidefaultSpace
end choose
end subroutine

public subroutine setbasewhere (string _value);// setBaseWhere( string _value )
isBaseWhere = _value

end subroutine

public function string getbasewhere ();// string = getBaseWhere()
return isBaseWhere

end function

public subroutine settitle (string _value);// setTitle( string _value )
isTitle = _value

end subroutine

public function string gettitle ();// string = getTitle()
return isTitle

end function

public function datawindow getreport ();// getReport()
return dw_report
end function

public subroutine doexcelexport ();// doExcelExport()
long rows

u_dwexporter exportr

rows = dw_report.rowcount()
if rows > 0 then 
	exportr.initialize()
	exportr.doExcelExport( dw_report, rows, true  )	
	exportr.cleanup()
end if



end subroutine

public function boolean getaddprojecttowhere ();// boolean getAddProjectToWhere()
return ibAddProjectToWhere

end function

public subroutine setaddprojecttowhere (boolean _value);// setAddProjectToWhere( boolean _value )
ibAddProjectToWhere = _value

end subroutine

public subroutine setparentwindow (ref window _value);// setParentWindow( ref window _value )
iwParent = _value


end subroutine

public function window getparentwindow ();// window = getParentWindow()
return iwParent

end function

public function integer initialize (ref window _parentwindow);// Initialize()
int max
int index
datawindow ldw


setParentWindow( _parentWindow )

// initialize the datawindows
max = UpperBound( control )
for index = 1 to max
	
	choose case TypeOf( control[ index ] )
		case Datawindow!
			ldw = control[index]
			ldw.settransobject(sqlca)
		case UserObject!
	end Choose

next

// get the sql and load locals
setOriginalSql( dw_report.getsqlselect() )

SqlUtil = create u_sqlutil
SqlUtil.setOriginalSQL( getOriginalSql() )
SqlUtil.doParseSql()
if getAddProjectToWhere() then
	SqlUtil.setNewWhere( ' Where' + getProjectColumnName() + ' = ~'' + Upper( gs_project ) + "' "  )
end if
if NOT isNull( sqlUtil.getWhere() ) then
	setBaseWhere( sqlUtil.getWhere() )
end if

event ue_resize()

return 0



end function

public subroutine doexcelexport (ref datawindow asdw);// doExcelExport(ref datawindow asdw )
long rows

u_dwexporter exportr

rows = dw_report.rowcount()
if rows > 0 then 
	exportr.initialize()
	exportr.doExcelExport( asdw, rows, true  )	
	exportr.cleanup()
end if




end subroutine

public subroutine setfromdatecol (string _column);// setFromDateCol( string _column )
int index
int max

max = UpperBound( isFromDateCols )
if isNull( max ) then max = 0
max++
isFromDateCols[ max ] = _column
end subroutine

public subroutine settodatecol (string _column);// setFromDateCol( string _column )
int index
int max

max = UpperBound( isToDateCols )
if isNull( max ) then max = 0
max++
isToDateCols[ max ] = _column
end subroutine

public function boolean isfromdatecolumn (string _column);// boolean = isFromDatecolumn( string _column )

int index
int max
boolean foundit

foundit = false
max = UpperBound( isfromdatecols )
for index = 1 to max
	if isFromDateCols[ index ] = _column then
		foundit = true
		exit
	end if
next
return foundit



end function

public function boolean istodatecolumn (string _column);// boolean = istoDatecolumn( string _column )

int index
int max
boolean foundit

foundit = false
max = UpperBound( istodatecols )
for index = 1 to max
	if isToDateCols[ index ] = _column then
		foundit = true
		exit
	end if
next
return foundit



end function

public subroutine setdefaultdate (string _column, boolean _from);// setDefaultDate( string _column, booleon _from )
datetime	ldt_date
string _style
string test

if String( dw_select.getItemDateTime( 1, _column ), "00/00/00" ) <> '' then return

_style = "END"
if _from then _style = "BEGIN"
ldt_date = f_get_date( _style )
dw_select.SetColumn( _column )
//dw_select.SetText(string(ldt_date, "mm/dd/yyyy hh:mm"))
dw_select.SetText(string(ldt_date))


			
end subroutine

public subroutine setprojectcolumnname (string _value);// setProjectColumnName( string _value )
isProjectColumn = _value


end subroutine

public function string getprojectcolumnname ();// string = getProjectColumnName()
return isProjectColumn

end function

event constructor;// u_std_tab_query

//
// pass in the two datawindows.  Datawindow 1 is the query/select datawindow
// datawindow 2 is the report, but you could tell that by looking at the following code.
//
// This object uses the u_dwexporter object so you need to add the right codes to the report datawindow
// tag fields.  See the constructor of u_dwexporter for full details.
//
// This object also utilizes the u_sqlutil object - see it's various methods and events to see if there's a utility 
// you need.
//
// For an example of this object in a working environment, see w_carton_serial_report.
//

str_parms	parms

parms = message.powerobjectparm
if UpperBound( parms.string_arg ) > 0 then
	if NOT isNull( parms.string_arg[1] ) and len( parms.string_arg[1] ) > 0 then 
		setCriteriaDataObject(parms.string_arg[1] )
	end if
	if NOT isNull( parms.string_arg[2] ) and len( parms.string_arg[2] ) > 0 then 
		setReportDataObject(parms.string_arg[2] )
	end if
end if





end event

on u_std_tab_query.create
this.cb_retrieve=create cb_retrieve
this.dw_report=create dw_report
this.dw_select=create dw_select
this.cb_report_reset=create cb_report_reset
this.Control[]={this.cb_retrieve,&
this.dw_report,&
this.dw_select,&
this.cb_report_reset}
end on

on u_std_tab_query.destroy
destroy(this.cb_retrieve)
destroy(this.dw_report)
destroy(this.dw_select)
destroy(this.cb_report_reset)
end on

type cb_retrieve from commandbutton within u_std_tab_query
boolean visible = false
integer x = 2761
integer y = 96
integer width = 279
integer height = 68
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Retrieve"
boolean default = true
end type

event clicked;window lwindow

lwindow = getParentWindow()
lwindow.event dynamic ue_retrieveReport()


end event

event constructor;
g.of_check_label_button(this)
end event

type dw_report from u_dw within u_std_tab_query
integer y = 204
integer width = 2875
integer height = 720
integer taborder = 30
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

event ue_resize;call super::ue_resize;int awidth
int aheight

setParentValues(  awidth, aheight )
this.width =   ( awidth -  ( iiDefaultSpace * 2 )  )
this.height = ( (parent.height - this.y) - ( 50 ) )
end event

event retrieveend;call super::retrieveend;sqlUtil.setWhere( getBaseWhere() ) // re-initialize where clause after retrieve
end event

type dw_select from u_dw within u_std_tab_query
integer width = 2734
integer height = 184
integer taborder = 30
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_resize;call super::ue_resize;int awidth
int aheight

setParentValues(  awidth, aheight )
this.width =   ( awidth - (cb_retrieve.width + ( iiDefaultSpace * 4 ) ) )

end event

event clicked;call super::clicked;
if isFromDateColumn( dwo.name ) then
	setDefaultDate( dwo.name,true )
end if
if isToDateColumn( dwo.name ) then
	setDefaultDate( dwo.name,false )
end if

end event

type cb_report_reset from commandbutton within u_std_tab_query
integer x = 2761
integer y = 12
integer width = 279
integer height = 68
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset"
end type

event clicked;parent.event ue_reset()

end event

event constructor;
g.of_check_label_button(this)
end event

