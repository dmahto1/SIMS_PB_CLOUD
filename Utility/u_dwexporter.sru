HA$PBExportHeader$u_dwexporter.sru
forward
global type u_dwexporter from nonvisualobject
end type
end forward

global type u_dwexporter from nonvisualobject autoinstantiate
end type

type variables
OleObject lole_OLE
OleObject lole_Sheet

end variables

forward prototypes
public subroutine getcolumns (ref datawindow adw_dw, ref string as_columns[])
public function any getdata (ref datawindow adw_dw, long al_row, string as_column)
public function string inttocolumn (integer ai_col)
public subroutine doexcelexport (ref datawindow adw_dw, long al_rows, boolean headers)
public subroutine initialize ()
public subroutine cleanup ()
public subroutine getheaders (ref datawindow adw_dw, ref string as_headers[])
public function integer getcolumnposition (string asvalue)
public function string getformattedheader (string asvalue)
public subroutine doexcelexportds (ref datastore adw_dw, long al_rows, boolean headers)
public subroutine getdsheaders (ref datastore adw_dw, ref string as_headers[])
public subroutine getdscolumns (ref datastore adw_dw, ref string as_columns[])
public function any getdsdata (ref datastore adw_dw, long al_row, string as_column)
end prototypes

public subroutine getcolumns (ref datawindow adw_dw, ref string as_columns[]);// getColumns( ref datawindow adw_dw, ref string as_columns[] )

string asValue
Long index, ll_Cols

ll_Cols = Long( adw_DW.Describe( 'datawindow.column.count' ) )
FOR index = ll_cols TO 1 STEP -1
	asValue = adw_DW.Describe( '#' + String( index ) + '.Tag' )
	if isNull( asValue) or len( asValue) = 0 or asValue = "?"  then continue
	as_columns[ getColumnPosition( asValue ) ] = adw_DW.Describe( '#' + String( index ) + '.Name' )
NEXT
end subroutine

public function any getdata (ref datawindow adw_dw, long al_row, string as_column);Long ll_Col
Any la_A

IF al_Row > adw_DW.RowCount() THEN RETURN ""
ll_Col = Long( adw_DW.Describe( as_Column + ".ID" ) )
IF ll_Col > 0 THEN &
   la_A = adw_DW.object.data.primary.current[ al_Row, ll_Col ]

RETURN la_A
end function

public function string inttocolumn (integer ai_col);// string = inttocolumn( int ai_col )
// Convert a column number into a spreadsheet column reference

String ls_Col
Integer li_Min, li_Max

IF ai_col <= 0 THEN RETURN ""

// calc the major/minor letters
li_Max = ai_col / 26
li_Min = ai_col - ( li_Max * 26 )

// Convert min and max to letters
IF li_Max > 0 THEN
	ls_Col = Char( 64 + li_Max )
END IF

ls_Col += String( Char( 64 + li_Min ) )

RETURN ls_Col

end function

public subroutine doexcelexport (ref datawindow adw_dw, long al_rows, boolean headers);// Export the data to Excel

String ls_Columns[]
String ls_headers[]
Long ll_Row, ll_Col, ll_Cols

SetPointer( HourGlass! )

this.GetHeaders( adw_DW, ls_headers )
this.GetColumns( adw_DW, ls_Columns )

if headers then
	ll_Cols = UpperBound( ls_headers )
	FOR ll_col = 1 TO ll_cols
		lole_Sheet.Cells[ 1, ll_Col ] = ls_headers[ ll_Col ]
	NEXT
end if

FOR ll_Row = 2 TO al_rows + 1
	FOR ll_Col = 1 TO ll_cols
		lole_Sheet.Cells[ ll_Row, ll_Col ] = &
		this.GetData( adw_DW, ll_Row - 1, ls_Columns[ ll_Col ] )
	NEXT
NEXT

lole_Sheet.Range( inttocolumn( 1 ) + "1:" + inttocolumn( ll_Cols ) + "1").Select
lole_OLE.Selection.Font.Bold = True

lole_Sheet.Range("A1:A1").Select
lole_Sheet.Columns( inttocolumn( 1 ) + ":" + inttocolumn( ll_cols ) ).EntireColumn.AutoFit

return

end subroutine

public subroutine initialize ();lole_OLE = CREATE OleObject

lole_OLE.ConnectToNewObject( 'excel.application' )

lole_OLE.Workbooks.Add

lole_sheet = lole_OLE.Application.ActiveWorkbook.WorkSheets[1]

end subroutine

public subroutine cleanup ();lole_OLE.Application.Visible = TRUE
lole_OLE.DisconnectObject()
DESTROY lole_OLE

end subroutine

public subroutine getheaders (ref datawindow adw_dw, ref string as_headers[]);string asValue
int cntr
Long index, ll_Cols

ll_Cols = Long( adw_DW.Describe( 'datawindow.column.count' ) )
FOR index = ll_cols TO 1 STEP -1
	asValue = adw_DW.Describe( '#' + String( index ) + '.Tag' )
	if isNull( asValue) or len( asValue) = 0 or asValue = "?" then continue
	as_headers[ getColumnPosition( asValue ) ] = GetFormattedHeader( asValue )
NEXT


end subroutine

public function integer getcolumnposition (string asvalue);// int = getColumnPosition( string asValue )

// the tag value contains the position + the header
// ie 10:Header Label
// strip of the digits and return them

int colonPos
string sPosition

colonPos = Pos( asValue,":" )
sPosition = left( asValue, ( colonPos -1 ) )

return integer( sPosition )


end function

public function string getformattedheader (string asvalue);// string = getFormattedHeader( string asValue )

// asValue = columnPosition:columnHeader

int columnPosition
string returnValue

columnPosition = Pos( asValue, ":" )
returnValue = right( asValue, ( len( asValue) - columnPosition ) )

return returnValue
end function

public subroutine doexcelexportds (ref datastore adw_dw, long al_rows, boolean headers);// Export the data to Excel

String ls_Columns[]
String ls_headers[]
Long ll_Row, ll_Col, ll_Cols

SetPointer( HourGlass! )

this.getdsHeaders( adw_DW, ls_headers )
this.getdsColumns( adw_DW, ls_Columns )

if headers then
	ll_Cols = UpperBound( ls_headers )
	FOR ll_col = 1 TO ll_cols
		lole_Sheet.Cells[ 1, ll_Col ] = ls_headers[ ll_Col ]
	NEXT
end if

FOR ll_Row = 2 TO al_rows + 1
	FOR ll_Col = 1 TO ll_cols
		lole_Sheet.Cells[ ll_Row, ll_Col ] = &
		this.GetdsData( adw_DW, ll_Row - 1, ls_Columns[ ll_Col ] )
	NEXT
NEXT

lole_Sheet.Range( inttocolumn( 1 ) + "1:" + inttocolumn( ll_Cols ) + "1").Select
lole_OLE.Selection.Font.Bold = True

lole_Sheet.Range("A1:A1").Select
lole_Sheet.Columns( inttocolumn( 1 ) + ":" + inttocolumn( ll_cols ) ).EntireColumn.AutoFit

return

end subroutine

public subroutine getdsheaders (ref datastore adw_dw, ref string as_headers[]);string asValue
int cntr
Long index, ll_Cols

ll_Cols = Long( adw_DW.Describe( 'datawindow.column.count' ) )
FOR index = ll_cols TO 1 STEP -1
	asValue = adw_DW.Describe( '#' + String( index ) + '.Tag' )
	if isNull( asValue) or len( asValue) = 0 or asValue = "?" then continue
	as_headers[ getColumnPosition( asValue ) ] = GetFormattedHeader( asValue )
NEXT


end subroutine

public subroutine getdscolumns (ref datastore adw_dw, ref string as_columns[]);// getColumns( ref datawindow adw_dw, ref string as_columns[] )

string asValue
Long index, ll_Cols

ll_Cols = Long( adw_DW.Describe( 'datawindow.column.count' ) )
FOR index = ll_cols TO 1 STEP -1
	asValue = adw_DW.Describe( '#' + String( index ) + '.Tag' )
	if isNull( asValue) or len( asValue) = 0 or asValue = "?"  then continue
	as_columns[ getColumnPosition( asValue ) ] = adw_DW.Describe( '#' + String( index ) + '.Name' )
NEXT
end subroutine

public function any getdsdata (ref datastore adw_dw, long al_row, string as_column);Long ll_Col
Any la_A

IF al_Row > adw_DW.RowCount() THEN RETURN ""
ll_Col = Long( adw_DW.Describe( as_Column + ".ID" ) )
IF ll_Col > 0 THEN &
   la_A = adw_DW.object.data.primary.current[ al_Row, ll_Col ]

RETURN la_A
end function

on u_dwexporter.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_dwexporter.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*
How to use.....

This object uses Ole to export datawindow to Excel.  The Column Header and Position is controlled
by the TAG value in the column to export. seperated by a colon. ie,  1:Header One, 2:Header Two.

see reports.pble\d_fwd_pick_replenish_export for an example

If the Tag value is NULL then the column is skipped.

Note:   if the select returns a null value, the column is skipped.  This is a issue with excel.  The
		   way to get around this is to include the isNull() function in the select.
			
		  As in....
		 
		 Select IsNull( columnA, 0 ) as columnA,
		 		   IsNull( columnB, "" ) as columnB,  
		 From someTable;
		 
Sample Code.....

// ue_saveasExcel()

long rows
long index

// u_dwexporter is autoinstanciated

u_dwexporter exportr

// Initializes the excel OLE 
exportr.initialize()

// do the work...

rows = dw_report.rowcount()
for index = 1 to rows
	exportr.doExcelExport( dw_report, index , ( index = 1)  )
next

// Destroy objects etc...
exportr.cleanup()

*/

end event

