$PBExportHeader$u_dw_import_server.sru
$PBExportComments$Generic UO for server based imports
forward
global type u_dw_import_server from u_dw_import
end type
end forward

global type u_dw_import_server from u_dw_import
event ue_after_save ( )
event ue_pre_import_new ( )
end type
global u_dw_import_server u_dw_import_server

type variables
datastore ids_codes
datawindow idw_import
boolean ibShowDetails = FALSE    // useful for debugging
long fId = 0							// file ID

end variables

event ue_after_save();
integer li_idx

CHOOSE CASE this.dataobject 
		
CASE "d_import_so"
	
	
	for li_idx =1 to this.RowCount()
		
		
		
	next
	
	
END CHOOSE
	
end event

on u_dw_import_server.create
call super::create
end on

on u_dw_import_server.destroy
call super::destroy
end on

event ue_pre_import;call super::ue_pre_import;// gwm 11/7/2014 - Decide which delimiter to use before import
string thisColumn
string sSKU = ''
string sDesc = ''
long   lCol_Num = 0
string sCust_Code = ''  // 2nd Row Loc Description = Customer.Cust_code
string sOwnerCd = ''
string sWH_Code = ''  // Customer.Cust_code -> Customer.User_Field2
long   lOwner_Id = 0	 // 2nd Row Loc Code = Owner.Owner_code -> Owner.Owner_id
long 	 lMin_ROP = 0  	// from MIN column in file
Long 	 lMin = 0		// for a set
Long 	 lMax = 0		// for a set
string sProject_Id = 'PANDORA'
string sSupp_Code  = 'PANDORA'
long   lMAX_Supply_Onhand = 0		//
long   lReorder_qty = 0
string sProjectCode = 'MAIN'  // (PoNo) DCOPS only uses the MAIN project Code at this point 
string sDefProjCode = 'MAIN'

string sSerialNo, lsSkuFound,lsPno2ControlledInd ,lsContainerTrackingInd
DateTime	ldttoday
Long lSkuCount

boolean bInvalidOwnerCode = FALSE
boolean bInvalidSKU = FALSE
boolean bInvalidMinMax = FALSE
string  sInvalidOwner = 'Invalid Owner code(s) found'
string  sInvalidSKU = 'Invalid SKU(s) found'
string  sInvalidMinMax = 'Invalid MIN/MAX value(s) found'
string  sImportErrors = 'Import errors were found. Please correct and re-import: ~r~n '
string  sNL = ' ~r~n'

string sCustCds[]
string sLine = ''		// a line from the file
long rtn = 0
long lImportRow = 0
string quote = String(Blob(Char(34)), EncodingANSI!)
string comma = ','
string tabchar = '~t'
string pipechar = '|'
string delimiter = comma	// set up the system to use comma as the default delimiter
long lposComma
long lposPipe
long lposTab

long lpos = 0			// used for pos search
long lpos2 = 0 			// find quotes
long llen = 0  		// string length
long i = 0				// iterator
long cnt = 0         // counter
long lTotalNumSets = 0	// Total number of sets to import
long lSetCnt = 0
string lsFile = ''
string ss = ''
long ldr = 0
string sMsg = ''
long lrst = 0
string sErrorRows = 'Errors in import file in rows: '  // holds list of row numbers with errors

/*********Get DW display columns*************/
 Long li_Loop, ll_columns
  String ls_ColName, lsa_ColNames[],lsDataType,lsaDataType[]
  //this = w_import.dw_import
  
  Any la_colno
	la_colno = this.object.datawindow.column.count
	ll_columns = long(la_colno)
  FOR li_Loop = 1 TO ll_columns
    ls_ColName = this.Describe("#" + String( li_Loop ) + ".Name")
	 lsDataType = this.Describe("#" + String( li_Loop ) + ".Coltype")
    IF Long( this.Describe( ls_ColName + ".Visible") ) > 0 THEN
      lsa_ColNames[ UpperBound(lsa_ColNames[]) + 1] = ls_ColName
		lsaDataType[ UpperBound(lsaDataType[]) + 1] = lsDataType
    END IF

 next
/**************************************/

// create the ds to hold the code translations
ids_codes = CREATE datastore
//ids_codes.DataObject = "d_import_po"
ids_codes.DataObject = this.dataobject
ids_codes.SetTransobject( SQLCA )
ids_codes.reset( )

// open file in line mode

If IsValid(w_import) then 
	lsFile = w_import.isPath 
	//lsFile = 'TEST.csv'
End If

fId = fileopen ( lsFile, LineMode!, Read!)

rtn = FileReadEx( fId, sLine )  // 2rd row - Determine num of columns and location codes; add to ds
if IsNull(rtn) OR (rtn <= 0 ) then
	sMsg = "There appears to be a problem with the file - ~r~n" &
	      + " either the format is incorrect or the file couldn't be opened. ~r~n" &
			+ " Please check the file and try again."
	MessageBox('Import Error', sMsg )
	RETURN
else
	llen = len(sLine)
//	lImportRow ++
end if

ldtToday = f_getLocalWorldTime( gs_default_wh )

// determine the delimiter to use
lposComma = 0
lposPipe = 0
lposTab = 0

lposComma = pos(sLine, comma, 1)
lposPipe  = pos(sLine, PipeChar, 1)
lposTab   = pos(sLine, TabChar, 1)

IF lposComma > 0 THEN
	delimiter = comma
ELSEIF lposPipe > 0 THEN
	delimiter = PipeChar
ELSEIF lposTab > 0 THEN
	delimiter = TabChar
ELSE
	MessageBox('ERROR', 'Unable to determine delimiter. ~r~n' &
		+ 'Please confirm that the file uses either the comma, tab or pipe characters as column markers' )
END IF

DO WHILE ( rtn > 0)
	
	lImportRow ++
	// write to the status line
	w_main.SetMicroHelp( 'Processing row: ' + string(lImportRow) + ': ' + sLine)
	
	llen = len(sLine)
	i = 1
	cnt = 0
	
	DO UNTIL (i >= llen)
		// get the columns
		cnt++ // increment column counter
		
		lpos = pos(sLine, delimiter, i)
		if lpos > 0 then
			ss = mid(sLine, i, lpos - i)
			// how to deal with embedded quotes and delimiters:
			// Test for quote and if found then find match and set i and lpos appropriately
			If left(ss,1) = quote Then
				lpos2 = pos(sLine, quote, lpos + 1)
				if lpos > 0 then
					ss = mid(sline, i + 1, lpos2 - i - 1) 
					i = lpos2 + 2
					//lpos = lpos2
				end if
			else
				i = lpos + 1
			End if
		elseif lpos = 0 and i = 0 then
			ss = ''
			i++
			cnt --
		else
			ss = mid(sLine, i)
			i = llen 
		end if
		
		thisColumn = upper(lsa_ColNames[cnt])
		if upper(thisColumn) = 'ORDER_DATE' or upper(thisColumn) = 'SCHEDULE_DATE' &
			or upper(thisColumn) = 'SCHEDULED_DATE' 	or upper(thisColumn) = 'REQUEST_DATE' &
			or upper(thisColumn) = 'EXPIRATION_DATE' or upper(thisColumn) = 'NEED_BY_DATE' then
			if len(ss) = 8 then
				ss = left(ss,4) + '-' + mid(ss,5,2) + '-' + right(ss,2)
			end if
		end if
		
		// Add column data to DS
		If cnt = 1 Then 
			If left(upper(ss),4) = left(upper(thisColumn),4) Then
				// Header row - do not process
				EXIT
			Else
				ldr =ids_codes.insertrow(0)
				ids_codes.setitem( ldr, thisColumn, ss)
			End If
		Else
			ids_codes.setitem( ldr, thisColumn, ss)
		End If
				
	LOOP // Parse through the colunns
	
	rtn = FileReadEx( fId, sLine )  // row 5+ data

LOOP  // Rows 4+

rtn = FileClose(fId)

ids_codes.rowscopy( 1, ids_codes.rowcount(), Primary!, this, 1, Primary!)



end event

