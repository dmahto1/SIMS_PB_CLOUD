$PBExportHeader$u_dw_import_pandora_minmax.sru
$PBExportComments$Process complex import logic for Pandora min/max values
forward
global type u_dw_import_pandora_minmax from u_dw_import
end type
end forward

global type u_dw_import_pandora_minmax from u_dw_import
integer width = 3214
integer height = 1864
string title = "Pandora MinMax import"
string dataobject = "d_import_pandora_minmax"
end type
global u_dw_import_pandora_minmax u_dw_import_pandora_minmax

type variables
datastore ids_codes
boolean ibShowDetails = FALSE    // useful for debugging
long fId = 0							// file ID

end variables

forward prototypes
public function integer wf_save ()
public function string wf_validate (long al_row)
end prototypes

public function integer wf_save ();// user has chosen to save the data!
long 		lrtn = 0
long     lcnt = 0
long     lRows = 0
long     lTotalNumSets = 0
long     lSetCnt = 0
string 	sMsg = ''
string   sOwnerIds = ''
long     lOwnerId = 0
string   sWh_Code = ''
string   sSupp_code = 'PANDORA'
string   sProject_ID = 'PANDORA'
string   sSKU = ''
string   sPONO = 'MAIN'
long     lOwner_ID = 0
long     lMax = 0
long     lMin = 0
long     lReorder = 0
boolean  bSaveErrorsFound = FALSE

boolean	bDeletePerOwner = FALSE

If IsValid(w_import) Then
	w_import.cb_validate.Enabled = FALSE
	w_import.cb_convert.Enabled = FALSE
	w_import.cb_archive.Enabled = FALSE
	w_import.cb_save.Enabled = FALSE
	w_import.cb_insert.Enabled = FALSE
	w_import.cb_delete.Enabled = FALSE
	w_import.cb_print.Enabled = FALSE
	w_import.cb_ok.Enabled = FALSE
	w_import.cb_import.Enabled = FALSE
End If

// Check with the user for replace or update ...
sMsg = 'Delete Existing MIN/MAX for Owners?'
lrtn = MessageBox('Import', sMsg, Question!, YesNo!, 1)

IF lrtn = 1 THEN
	// delete all existing records per Owner when owner changes
	bDeletePerOwner = TRUE
	
	if IsValid(ids_codes) then
		// cycle through the owner codes and delete all the records
		lTotalNumSets = ids_codes.rowcount( )
		
		FOR lSetCnt = 1 to lTotalNumSets
			//sOwnerIds = sOwnerIds + STRING(ids_codes.GetItemNumber( lSetCnt, 'import_owner_id' )) + ', '
			lOwnerId = ids_codes.GetItemNumber( lSetCnt, 'import_owner_id' )
			
			DELETE Reorder_Point 
			WHERE Project_ID = :sProject_ID 
			AND owner_id = :lOwnerId
			USING SQLCA;
			
			IF (SQLCA.sqlcode <> 0) THEN
				// error - return
				sMsg = 'There was an error removing the old records for Cust Num: ' &
				    + ids_codes.GetItemString( lSetCnt, 'import_cust_code') + ' ~n~r' &
					 + SQLCA.sqlerrtext
				MessageBox ('ERROR', sMsg )
				lrtn = -1
				//RETURN -1
			ELSE
				lrtn = 1
			END IF
			
		NEXT
		
		// get rid of the last comma
		sOwnerIds = LEFT(sOwnerIds, len(sOwnerIds) - 2 )
		
	else
		sMsg = 'There appears to be an internal memory problem. Please cancel and close the import window. ~r~n' &
			+ 'If the problem reoccurs, please restart SIMS and/or contact support. ' 
		MessageBox('ERROR', sMsg )
		lrtn = -1
		//return -1
		
	end if
	
ELSE
	// process records as updates or inserts
	bDeletePerOwner = FALSE
END IF
	
FOR lcnt = 1 to this.rowcount( )
	// process the rows
	sSKU = this.getitemstring( lcnt, 'sku' )
	sSupp_Code = this.getitemstring( lcnt, 'supp_code' )
	sWh_Code = this.getitemstring( lcnt, 'wh_code' )
	lMax = this.getitemnumber( lcnt, 'max_supply_onhand' )
	lMin = this.getitemnumber( lcnt, 'min_rop' )
	lreorder = this.getitemnumber( lcnt, 'reorder_qty' )
	lowner_ID = this.getitemnumber( lcnt, 'owner_id' )
	sPONO = this.getitemstring( lcnt, 'pono' )
	if IsNull(sPONO) OR sPONO = '' then
		sPONO = 'MAIN'
	end if
	
	SELECT count(*) INTO :lRows
	FROM Reorder_Point P
	WHERE p.project_id = :sProject_ID
	  AND p.SKU = :sSKU
	  AND p.Supp_Code = :sSupp_Code
	  AND p.WH_Code = :sWH_Code
	  AND p.owner_id = :lOwner_ID
	USING SQLCA;
	
	IF lRows = 1 THEN
		// update
		UPDATE Reorder_Point
		SET MAX_Supply_Onhand = :lMax,
			 MIN_ROP = :lMin,
			 Reorder_Qty = :lReorder,
			 PONO = :sPONO
		WHERE project_id = :sProject_ID
		  AND SKU = :sSKU
		  AND Supp_Code = :sSupp_Code
		  AND WH_Code = :sWH_Code
		  AND owner_id = :lOwner_ID
		USING SQLCA;
		
		//check for errors
		IF (SQLCA.sqlcode <> 0) AND (SQLCA.sqlnrows <= 0) THEN
			sMsg = 'There was an error updating the old records: ~n~r' + SQLCA.sqlerrtext
			MessageBox ('ERROR', sMsg )
			lrtn = -1
			//RETURN -1
		ELSE
			lrtn = 1
		END IF
		
	ELSE
		// insert
		INSERT INTO Reorder_Point (Project_ID, SKU, Supp_Code, WH_Code, 
			MAX_Supply_Onhand, MIN_ROP, Reorder_Qty, owner_id, PONO )
		VALUES (:sProject_ID, :sSKU, :sSupp_Code, :sWH_Code,
			:lMax, :lMin, :lReorder, :lOwner_ID, :sPONO	)
		USING SQLCA;
		
		//check for errors
		IF SQLCA.sqlcode <> 0 THEN
			sMsg = 'There was an error inserting the new record: ~n~r' &
				+ " It is likely that this was due to a SKU that isn't in Item Master. ~r~n" &
				+ SQLCA.sqlerrtext
			MessageBox ('ERROR', sMsg )
			lrtn = -1
			bSaveErrorsFound = TRUE
			
		ELSE
			lrtn = 1
		END IF
	
	END IF

NEXT

IF lrtn <> 1 then
	If IsValid(w_import) Then
		w_import.cb_validate.Enabled = FALSE
		w_import.cb_convert.Enabled = FALSE
		w_import.cb_archive.Enabled = FALSE
		w_import.cb_save.Enabled = FALSE
		w_import.cb_insert.Enabled = FALSE
		w_import.cb_delete.Enabled = FALSE
		w_import.cb_print.Enabled = FALSE
		w_import.cb_ok.Enabled = FALSE
		w_import.cb_import.Enabled = FALSE
	End If

ELSEIF lrtn = 1 AND bSaveErrorsFound THEN
	MessageBox('Info', 'Some Changes successfully saved.')
	
	If IsValid(w_import) Then
		w_import.cb_import.Enabled = TRUE
		w_import.cb_ok.Enabled = TRUE
	End If

ELSEIF lrtn = 1 AND NOT bSaveErrorsFound THEN
	MessageBox('Info', 'Changes successfully saved.')
	
	If IsValid(w_import) Then
		w_import.cb_import.Enabled = TRUE
		w_import.cb_ok.Enabled = TRUE
	End If
	
END IF
	
RETURN lrtn



end function

public function string wf_validate (long al_row);// this is where we check for an invalid row - called for EACH row
STRING sRtn

If this.rowcount() > 0 and al_row >= 1 then
	// check this row
	IF this.getitemstring(al_row, 'wh_code') = 'INVALID' THEN
		sRTN = 'Invalid WH_CODE, row: ' + string(al_row)
	ELSE
		sRtn = ''  // the convention for 'okay'
		If IsValid(w_import) Then
			w_import.cb_save.Enabled = FALSE
		End If

	END IF
	
end if

RETURN sRtn


end function

on u_dw_import_pandora_minmax.create
call super::create
end on

on u_dw_import_pandora_minmax.destroy
call super::destroy
end on

event ue_pre_import;call super::ue_pre_import;/* *****************************************************
 *  Function: ImportPandoraMinMax()  ... ue_pre_import()
 *  	Import and process a cross-tab like CSV file containing SKUs, related data, and Min/Max restocking level values
 *		for specified locations -- this is for Pandora;
 *
 *		Process the header and determine locations and the column pairs for each location												Loc Description	Council Bluffs	
 *																																											  Loc Code		CBF	CBF
 * GPN	Manufacturer Part Number	Part Description	Date Added	Product Type	Min	Max	Lifetime Spares	LT (in wks)	Local Buy	MIN/MAX	Min 	Max
 *		
 *	ET3: 2012-05-17
 **************************************************** */
 
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
string comma = ','
string tabchar = '~t'
string pipechar = '|'
string delimiter = comma	// set up the system to use comma as the default delimiter
long lposComma
long lposPipe
long lposTab

long lpos = 0			// used for pos search
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


// Deal with the import window
If IsValid(w_import) Then
	w_import.cb_validate.Enabled = FALSE
	w_import.cb_convert.Enabled = FALSE
	w_import.cb_archive.Enabled = FALSE
	w_import.cb_save.Enabled = FALSE
	w_import.cb_insert.Enabled = FALSE
	w_import.cb_delete.Enabled = FALSE
	w_import.cb_print.Enabled = FALSE
	w_import.cb_ok.Enabled = FALSE
	w_import.cb_import.Enabled = FALSE
End If

// create the ds to hold the code translations
ids_codes = CREATE datastore
ids_codes.DataObject = "d_import_pandora_codes"
ids_codes.SetTransobject( SQLCA )
ids_codes.reset( )

// open file in line mode

If IsValid(w_import) then 
	lsFile = isFilePath 
	//lsFile = 'TEST.csv'
End If

fId = fileopen ( lsFile, LineMode!, Read!)

// read in header rows 
// ignore 1st rows
rtn = FileReadEx( fId, sLine )
if rtn >= 0 then lImportRow ++

rtn = FileReadEx( fId, sLine )  // 2rd row - Determine num of columns and location codes; add to ds
if IsNull(rtn) OR (rtn <= 0 ) then
	sMsg = "There appears to be a problem with the file - ~r~n" &
	      + " either the format is incorrect or the file couldn't be opened. ~r~n" &
			+ " Please check the file and try again."
	MessageBox('Import Error', sMsg )
	RETURN
else
	llen = len(sLine)
	lImportRow ++
end if

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

do until (i >= llen)
	// get the columns
	lpos = pos(sLine, delimiter, i)

	cnt++ // increment column counter
	
	if lpos > 0 then
		ss = mid(sLine, i, lpos - i )
		i = lpos + 1
	elseif lpos = 0 and i = 0 then
		ss = ''
		i++
		cnt --
	else
		ss = mid(sLine, i)
		i = llen 
	end if
	
	if (ss <> '') and (Not IsNull(ss)) and (ss <> ',') then
		// we've successfully read in one column
		// test for col 14, 16, 18, etc
		if cnt >= 14 and ( mod(cnt, 2) = 0) then
			// add to ds
			lTotalNumSets++
			sCust_Code = ss
			
			// determine codes
			lCol_Num = cnt
			sOwnerCd = sCust_Code
			 
			SELECT C.User_Field2, O.owner_id
			INTO :sWH_Code, :lOwner_Id
			FROM Customer c, Owner o
			where c.Cust_Code = :sCust_Code
			AND O.Owner_Cd = C.Cust_Code
			USING SQLCA;
			
			if SQLCA.sqlcode <> 0 then
				bInvalidOwnerCode = TRUE
				sErrorRows += ',' + string(lImportRow)
				
				// insert error values so that the columns stay aligned
				ldr = ids_codes.insertrow(0)
				lrst = ids_codes.SetItem( ldr, 'import_col_num', lCol_Num )
				lrst = ids_codes.SetItem( ldr, 'import_cust_code', sCust_Code )
				lrst = ids_codes.SetItem( ldr, 'import_owner_cd', sCust_Code )
				lrst = ids_codes.SetItem( ldr, 'import_wh_code', 'INVALID' )
				lrst = ids_codes.SetItem( ldr, 'import_owner_id', 999999 )
				
			else							
				ldr = ids_codes.insertrow(0)
				lrst = ids_codes.SetItem( ldr, 'import_col_num', lCol_Num )
				lrst = ids_codes.SetItem( ldr, 'import_cust_code', sCust_Code )
				lrst = ids_codes.SetItem( ldr, 'import_owner_cd', sCust_Code )
				lrst = ids_codes.SetItem( ldr, 'import_wh_code', sWH_Code )
				lrst = ids_codes.SetItem( ldr, 'import_owner_id', lOwner_Id )
			
			end if
			
			// write to the status line
			/*   
			w_main.SetMicroHelp( 'Owner Cd: ' + sCust_Code &
					+ ' WH_code: ' + sWH_Code + ' Owner_Id: ' + String(lOwner_Id) )
			*/
			
		end if	
	end if
loop

// read in data rows - for each location, read in min/max values and insert row into dw 
rtn = FileReadEx( fId, sLine )  // skip additional header row
lImportRow ++

rtn = FileReadEx( fId, sLine )  // row 4 data
DO WHILE ( rtn > 0)
	
	lImportRow ++
	// write to the status line
	w_main.SetMicroHelp( 'Processing row: ' + string(lImportRow) + ': ' + sLine)
	
	llen = len(sLine)
	i = 0
	cnt = 0
	
	DO UNTIL (i >= llen)
		// get the columns
		cnt++ // increment column counter
		
		lpos = pos(sLine, delimiter, i)
		if lpos > 0 then
			ss = mid(sLine, i, lpos - i)
			i = lpos + 1
			// how to deal with embedded quotes and delimiters???
			// maybe test for quote and if found then find match and set i and lpos appropriately?
		elseif lpos = 0 and i = 0 then
			ss = ''
			i++
			cnt --
		else
			ss = mid(sLine, i)
			i = llen 
		end if
		
		IF cnt = 2 THEN //SKU
			sSKU = TRIM(ss)
		
		ELSEIF cnt = 13 THEN  // now process the PONO - project code
			lSetCnt = 0
			
			If IsNull(ss) OR (TRIM(ss) = '') Then
				sProjectCode = sDefProjCode
			Else
				sProjectCode = TRIM(ss)
			End If
						
			//move to first set
			DO WHILE lSetCnt < lTotalNumSets
				
				lSetCnt++ 	// increment set counter
				cnt++ 		// increment column counter even numbers - e.g. 14

				lpos = pos(sLine, delimiter, i)
				if lpos > 0 then
					ss = mid(sLine, i, lpos - i)
					i = lpos + 1
				else
					ss = mid(sLine, i)
					i = llen 
				end if
		
				// should be MIN
				If IsNumber(ss) then 
					lMin = LONG(ss)
				else
					SetNull(lMin)
				end if
				
				cnt++ 		// increment column counter Odd numbers - e.g. 15

				lpos = pos(sLine, delimiter, i)
				if lpos > 0 then
					ss = mid(sLine, i, lpos - i)
					i = lpos + 1
				else
					ss = mid(sLine, i)
					i = llen 
				end if

				// should be MAX
				If IsNumber(ss) then 
					lMax = LONG(ss)
				else
					SetNull(lMax)
				end if
				
				// Okay .. now let's see if this is data to actually use in the import
				IF (lmin > 0) AND (lmax > 0) AND (lmax >= lmin) THEN 
					IF lMax > lMin THEN
						lReorder_qty = lMAX - lMin
					ELSEIF lMin = lMax THEN
						lReorder_qty = lMAX
					ELSEIF lMin > lMax THEN
						bInvalidMinMax = TRUE
						sErrorRows += ',' + string(lImportRow)
					END IF

					sWH_Code = ids_codes.GetItemString( lSetCnt, 'import_wh_code')
					sCust_Code = ids_codes.GetItemString( lSetCnt, 'import_cust_code')
					lOwner_Id = ids_codes.GetItemNumber( lSetCnt, 'import_owner_id')
					
					If IsNull(sWH_Code) or IsNull(sCust_Code) or IsNull(lOwner_ID) then
						// real problem - for some unknown reason can't get the values
						MessageBox('ERROR', 'There was an error parsing the file. Please exit and restart.')
						CONTINUE
					End If
					
					ldr = This.insertrow(0)
					this.setitem( ldr, 'sku', sSKU )
					this.setitem( ldr, 'owner_cd', sCust_Code ) 
					this.setitem( ldr, 'supp_code', sSupp_Code ) 
					this.setitem( ldr, 'wh_code', sWH_Code ) 
					this.setitem( ldr, 'MAX_Supply_Onhand', lMax ) 
					this.setitem( ldr, 'min_rop', lMin )
					this.setitem( ldr, 'reorder_qty', lReorder_qty )
					this.setitem( ldr, 'owner_id', lOwner_Id )
					this.setitem( ldr, 'pono', sProjectCode )
					
				ELSEIF (lMin <= 0) OR (lMax <= 0) THEN
					bInvalidMinMax = TRUE
					sErrorRows += ',' + string(lImportRow)

				ELSE
					// oh well, too bad - no usable data
					lReorder_qty = 0

				END IF
					
			LOOP // through the sets
			
		END IF // column test

	LOOP // Parse through the colunns
	
	rtn = FileReadEx( fId, sLine )  // row 5+ data

LOOP  // Rows 4+

rtn = FileClose(fId)

IF bInvalidOwnerCode	OR bInvalidSKU OR bInvalidMinMax THEN
	IF bInvalidOwnerCode then sImportErrors = sImportErrors + sInvalidOwner + sNL
	IF bInvalidSKU then sImportErrors = sImportErrors + sInvalidSKU + sNL
	IF bInvalidMinMax then sImportErrors = sImportErrors + sInvalidMinMax + sNL
	
	If IsValid(w_import) Then
		w_import.cb_validate.Enabled = TRUE
		w_import.cb_convert.Enabled = FALSE
		w_import.cb_archive.Enabled = FALSE
		w_import.cb_save.Enabled = FALSE
		w_import.cb_insert.Enabled = FALSE
		w_import.cb_delete.Enabled = TRUE
		w_import.cb_print.Enabled = TRUE
		w_import.cb_ok.Enabled = FALSE
	End If
	
	MessageBox('Import Error', sImportErrors + sNL + sErrorRows )

ELSE
	If IsValid(w_import) Then
		w_import.cb_validate.Enabled = TRUE
		w_import.cb_convert.Enabled = FALSE
		w_import.cb_archive.Enabled = FALSE
		w_import.cb_save.Enabled = TRUE
		w_import.cb_insert.Enabled = FALSE
		w_import.cb_delete.Enabled = TRUE
		w_import.cb_print.Enabled = TRUE
		w_import.cb_ok.Enabled = TRUE
		w_import.cb_import.Enabled = FALSE
	End If
	
END IF

	
end event

event destructor;call super::destructor;// closing ... close the datastore
if IsValid(ids_codes) then 
	// clean-up
	DESTROY ids_codes
end if

//clean up any accidently left open file
if Not IsNull(fID) Then
	FileClose(fID)
end if
end event

event sqlpreview;call super::sqlpreview;// useful for debugging

string  sMsg = ''

IF ibShowDetails THEN
	sMsg = sqlsyntax
	Messagebox('INFO', sMsg)
END IF
	
end event

event constructor;call super::constructor;If IsValid(w_import) Then
	w_import.cb_validate.Enabled = FALSE
	w_import.cb_convert.Enabled = FALSE
	w_import.cb_archive.Enabled = FALSE
	w_import.cb_save.Enabled = FALSE
	w_import.cb_insert.Enabled = FALSE
	w_import.cb_delete.Enabled = FALSE
	w_import.cb_print.Enabled = FALSE
	w_import.cb_ok.Enabled = FALSE
	w_import.cb_import.Enabled = TRUE
End If


end event

