HA$PBExportHeader$w_comcast_multiplemacid.srw
forward
global type w_comcast_multiplemacid from w_master
end type
type cb_help from commandbutton within w_comcast_multiplemacid
end type
type cb_done from commandbutton within w_comcast_multiplemacid
end type
type cbx_showall from checkbox within w_comcast_multiplemacid
end type
type st_msg from statictext within w_comcast_multiplemacid
end type
type cb_mark_as_processed_only from commandbutton within w_comcast_multiplemacid
end type
type cb_export from commandbutton within w_comcast_multiplemacid
end type
type cb_process_selected from commandbutton within w_comcast_multiplemacid
end type
type cb_refresh from commandbutton within w_comcast_multiplemacid
end type
type dw_multiplemacids from u_dw_ancestor within w_comcast_multiplemacid
end type
type st_help from statictext within w_comcast_multiplemacid
end type
end forward

global type w_comcast_multiplemacid from w_master
integer width = 4023
integer height = 1488
string title = "Comcast Multiple Mac Id Repair Tool"
cb_help cb_help
cb_done cb_done
cbx_showall cbx_showall
st_msg st_msg
cb_mark_as_processed_only cb_mark_as_processed_only
cb_export cb_export
cb_process_selected cb_process_selected
cb_refresh cb_refresh
dw_multiplemacids dw_multiplemacids
st_help st_help
end type
global w_comcast_multiplemacid w_comcast_multiplemacid

type variables
BOOLEAN ibSelected = FALSE
BOOLEAN ibHelp = FALSE

String isHelp


end variables

event open;call super::open;/*******************************************************
*	Process Duplicate MAC IDs 
*
*  Utility to process the imports from COMCAST that fail due to instances of multiple
*	MAC Ids (user_field1).  Provides option to rename duplicates to non-conflicting pattern
*
*  by Ermine Todd - 2012/03/05
*
********************************************************/
pointer oldpointer
long    lRtn = 0

// retrieve records from work table
oldpointer = SetPointer(HourGlass!)

dw_multiplemacids.SetTransObject( SQLCA )
lRtn = dw_multiplemacids.Retrieve( 0 )  // parameter is for 'process_state' = false (0) show only unprocessed rows

IF lRtn > 0 THEN
	cb_export.enabled = TRUE
ELSE
	cb_export.enabled = FALSE
END IF

/* Help setup */
	ibHelp = TRUE
	dw_multiplemacids.BringToTop = TRUE
	cb_help.text = 'Help On'

isHelp = 'MULTIPLE MAC ID REPAIR TOOL HELP~n~r~n~r' +&
	space(5)  + '1.  If the original serial number pallet is still in stock, do not change the Mac Id to OLD- since the SN still needs to be shipped.~n~r' +&
	space(10) + 'In this case, contact the originator to determine which serial number owns the Mac Id.~n~r~n~r' + space(15) + 'a.  If the SN in ITH/ITD is' +& 
	' in error, have the vendor resubmit with the correct data and use the Mark as Processed button to mark the record as~n~r' + space(20) +' processed.~n~r ' +&
	space(10) + '~n~r' +&
	space(15) + 'b.  If the original serial numbers Mac Id is wrong, request IT assistance to update the carton serial record.~n~r~n~r' +&
	space(5)  + '2.  When a record is updated by Process Selected, it changes the ITH/ITD record status to New from Error.  This allows the record to be~n~r' +&
	space(10) + 'reprocessed.  Use the ITH/ITD Tool - ProcessITH button.  The record will be sent to carton serial.~n~r~n~r' +&
	space(5)  + '3.  Pressing the Mark as Processed button will mark the record as processed but will also ask if you wish to reprocess the ITH/ITD record.~n~r' +&
	space(10) + 'A Yes answer will change the ITH/ITD record status to New and allow you to process the file into carton serial.'
	
	st_help.text = isHelp


SetPointer(oldpointer)


end event

on w_comcast_multiplemacid.create
int iCurrent
call super::create
this.cb_help=create cb_help
this.cb_done=create cb_done
this.cbx_showall=create cbx_showall
this.st_msg=create st_msg
this.cb_mark_as_processed_only=create cb_mark_as_processed_only
this.cb_export=create cb_export
this.cb_process_selected=create cb_process_selected
this.cb_refresh=create cb_refresh
this.dw_multiplemacids=create dw_multiplemacids
this.st_help=create st_help
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_help
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.cbx_showall
this.Control[iCurrent+4]=this.st_msg
this.Control[iCurrent+5]=this.cb_mark_as_processed_only
this.Control[iCurrent+6]=this.cb_export
this.Control[iCurrent+7]=this.cb_process_selected
this.Control[iCurrent+8]=this.cb_refresh
this.Control[iCurrent+9]=this.dw_multiplemacids
this.Control[iCurrent+10]=this.st_help
end on

on w_comcast_multiplemacid.destroy
call super::destroy
destroy(this.cb_help)
destroy(this.cb_done)
destroy(this.cbx_showall)
destroy(this.st_msg)
destroy(this.cb_mark_as_processed_only)
destroy(this.cb_export)
destroy(this.cb_process_selected)
destroy(this.cb_refresh)
destroy(this.dw_multiplemacids)
destroy(this.st_help)
end on

event resize;call super::resize;long lminWidth = 1500
long lminHeight = 1384
long lborder = 100
long ltop = 284

if newwidth > lminWidth then
	// increase width of datawindow to correspond
	dw_multiplemacids.width = newwidth - lborder
else
	dw_multiplemacids.width = lminWidth
	this.width = lminWidth + lborder
end if

if newheight > lminHeight then
	// increase height of datawindow to correspond
	dw_multiplemacids.height = newheight - (lborder/2) - ltop
else
	dw_multiplemacids.height = lminHeight - ltop - (lborder/2)
	this.height = lminHeight + (lborder/2)
end if
end event

event mousemove;call super::mousemove;/* Show button tag below command buttons */

IF xpos >= cb_mark_as_processed_only.X AND (xpos <= cb_mark_as_processed_only.x + cb_mark_as_processed_only.Width) AND &
     ypos >= cb_mark_as_processed_only.y AND (ypos <= cb_mark_as_processed_only.y + cb_mark_as_processed_only.Height) THEN
   st_msg.text = cb_mark_as_processed_only.tag

ELSEIF xpos >= cb_process_selected.X AND (xpos <= cb_process_selected.x + cb_process_selected.Width) AND &
     ypos >= cb_process_selected.y AND (ypos <= cb_process_selected.y + cb_process_selected.Height) THEN
   		st_msg.text = cb_process_selected.tag
ELSEIF xpos >= cb_refresh.X AND (xpos <= cb_refresh.x + cb_refresh.Width) AND &
     ypos >= cb_refresh.y AND (ypos <= cb_refresh.y + cb_refresh.Height) THEN
   		st_msg.text = space(123) + cb_refresh.tag
ELSEIF xpos >= cb_export.X AND (xpos <= cb_export.x + cb_export.Width) AND &
     ypos >= cb_export.y AND (ypos <= cb_export.y + cb_export.Height) THEN
   		st_msg.text = space(145) + cb_export.tag
ELSEIF xpos >= cb_done.X AND (xpos <= cb_done.x + cb_done.Width) AND &
     ypos >= cb_done.y AND (ypos <= cb_done.y + cb_done.Height) THEN
   		st_msg.text = space(175) + cb_done.tag
ELSEIF xpos >= dw_multiplemacids.X AND (xpos <= dw_multiplemacids.x + dw_multiplemacids.Width) AND &
     ypos >= dw_multiplemacids.y AND (ypos <= dw_multiplemacids.y + dw_multiplemacids.Height) THEN
   		st_msg.text = dw_multiplemacids.tag
ELSE
  	 st_msg.text = ""
END IF

end event

type cb_help from commandbutton within w_comcast_multiplemacid
integer x = 1499
integer y = 84
integer width = 293
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Help On"
end type

event clicked;
If (ibHelp =TRUE) then
	ibHelp = FALSE
	st_help.BringToTop = TRUE
	cb_help.text = 'Help Off'
else
	ibHelp = TRUE
	dw_multiplemacids.BringToTop = TRUE
	cb_help.text = 'Help On'
end if

end event

type cb_done from commandbutton within w_comcast_multiplemacid
string tag = "Close window"
integer x = 3451
integer y = 64
integer width = 512
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Done"
end type

event clicked;
Close(Parent)

end event

type cbx_showall from checkbox within w_comcast_multiplemacid
integer x = 1856
integer y = 84
integer width = 334
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show All"
end type

event clicked;
cb_refresh.PostEvent(Clicked!)
end event

type st_msg from statictext within w_comcast_multiplemacid
string tag = "Mouse over buttons to show additional information"
integer x = 96
integer y = 180
integer width = 3867
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mouse over buttons to show additional information"
boolean focusrectangle = false
end type

type cb_mark_as_processed_only from commandbutton within w_comcast_multiplemacid
string tag = "Mark as processed without changes"
integer x = 41
integer y = 64
integer width = 617
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Mark as Processed"
end type

event clicked;// Cycle through the rows - for each selected row, change the row to processed then re-retrieve the rows;  
long 		ll_rowcnt = 0
long 		ll_currow = 0
string		s_quote = "'"
string 	s_mod = 'OLD-'
string 	s_csMAC_ID = ''
string   	s_csSerialNo = ''
long	 	l_selected_cnt = 0
string 	s_msg = ""
integer 	n_choice = 0
string 	s_csMAC_List = ''
string   	s_csSerialNo_List = ''
long		ll_test
boolean  b_fnd = FALSE
long     	l_rtn
string		s_itdTranNbr
string		s_itdSerialNo
string		s_itdSerialNo_List = ''
String  	SQL_Syntax

SQL_Syntax = "UPDATE Comcast_Dupe SET  Processed = 1 where Project_ID = 'COMCAST' and Serial_No IN ("

// disable this button - force a reset before reinvocation
//this.enabled = FALSE

IF IsValid(dw_multiplemacids) THEN
	FOR ll_currow = 1 to dw_multiplemacids.rowcount( )
		if 1 = (dw_multiplemacids.getitemnumber( ll_currow, 'indicator' ) ) then
			b_fnd = TRUE
		end if
	NEXT 
	
	IF b_fnd THEN
		l_selected_cnt = 0
		FOR ll_currow = 1 to dw_multiplemacids.rowcount( )
			if 1 = (dw_multiplemacids.getitemnumber( ll_currow, 'indicator' ) ) then
				s_itdSerialNo = dw_multiplemacids.GetItemString( ll_currow, 'serial_no')
				if ( s_itdSerialNo_List = '' ) then
					s_itdSerialNo_List = s_quote + s_itdSerialNo + s_quote
				else
					s_itdSerialNo_List = s_itdSerialNo_List + ",'" + s_itdSerialNo + s_quote
				end if
				
				l_selected_cnt ++
			End if
			
		NEXT  // row
		
		SQL_Syntax += s_itdSerialNo_List + ")"
		Execute Immediate "Begin Transaction" using SQLCA; 	
		Execute Immediate :SQL_Syntax;		
		If (SQLCA.SqlCode = 0) 	AND ( SQLCA.sqlnrows >= 1 ) Then	
			If messageBox("Mark as Processed","Do you also want these ITH/ITD records marked for processing into Carton/Serial?",Question!,YesNo!) = 1 Then
				SQL_Syntax = "UPDATE Comcast_ITD SET status = 'N' WHERE serial_no IN (" + s_itdSerialNo_List + ")"
				Execute Immediate :SQL_Syntax;
				If (SQLCA.SqlCode = 0) 	AND ( SQLCA.sqlnrows >= 1 ) Then	
					Execute Immediate "COMMIT" using SQLCA;
				Else
					Execute Immediate "ROLLBACK" using SQLCA;
					MessageBox('SQL Error','Update failed on update to Comcast_ITD')
				End if
			Else
				Execute Immediate "COMMIT" using SQLCA;
			End if
		Else
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox('SQL Error','Update failed on update to Comcast_Dupe')
		End if
		
	END IF // rows found 
	
	cb_refresh.PostEvent(Clicked!)
	
	return l_selected_cnt
ELSE
	MessageBox('ERROR', 'Critical data error.  Please restart and try again')
	RETURN -1
END IF

end event

type cb_export from commandbutton within w_comcast_multiplemacid
string tag = "Export list to Excel spreadsheet"
integer x = 2875
integer y = 64
integer width = 512
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Export List"
end type

event clicked;// ET3 2012-06-07: add export functionality
string lsFileName = ''
long   lRtn = 0

IF IsValid(dw_multiplemacids) and (dw_multiplemacids.rowcount( ) > 0 ) THEN
	lRtn = dw_multiplemacids.saveas( lsFileName, Excel!, TRUE)
	
END IF
	
end event

type cb_process_selected from commandbutton within w_comcast_multiplemacid
string tag = "Process the selected entries.  Add OLD- prefix to current MacId and set ITD record to re-process"
integer x = 763
integer y = 64
integer width = 613
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Process Selected"
end type

event clicked;// cycle through the rows - for each selected row, change the csMACID (userfield1) to prepend 'OLD-' in front of the existing MAC_ID
// pop-up a dialog to confirm the action and if 'yes' then using a single transaction, update the database appropriately and 
// then re-retrieve the rows;  


long 		ll_rowcnt = 0
long 		ll_currow = 0
string 	s_mod = 'OLD-'
string 	s_csMAC_ID = ''
string   s_csSerialNo = ''
long	 	l_selected_cnt = 0
string 	s_msg = "Please confirm that you want the selected rows modified in the database."
integer 	n_choice = 0
string 	s_csMAC_List = ''
string   s_csSerialNo_List = ''
long		ll_test
boolean  b_fnd = FALSE
long     l_rtn
string		s_itdTranNbr
string		s_itdSerialNo

// disable this button - force a reset before reinvocation
//this.enabled = FALSE

IF IsValid(dw_multiplemacids) THEN
	FOR ll_currow = 1 to dw_multiplemacids.rowcount( )
		if 1 = (dw_multiplemacids.getitemnumber( ll_currow, 'indicator' ) ) then
			b_fnd = TRUE
		end if
	NEXT 
	
	IF b_fnd THEN
		n_choice = MessageBox("Confirm rename operation", s_msg, Question!, OKCancel!, 1)

		If n_choice = 1 Then
			
			l_selected_cnt = 0
			
			FOR ll_currow = 1 to dw_multiplemacids.rowcount( )
				if 1 = (dw_multiplemacids.getitemnumber( ll_currow, 'indicator' ) ) then
					//process row
					
					s_csMAC_ID = dw_multiplemacids.getitemstring( ll_currow, 'csMAC_ID')
					s_csSerialNo = dw_multiplemacids.getitemstring( ll_currow, 'csserialno')
					s_itdTranNbr = dw_multiplemacids.getitemstring( ll_currow, 'trans_nbr')
					s_itdSerialNo = dw_multiplemacids.getitemstring( ll_currow, 'serial_no')
					
					// update db - use a transaction
					update Carton_Serial
					set User_field1 = 'OLD-' + USER_field1
					where Project_ID = 'COMCAST'
					and Serial_No = :s_csSerialNo
					USING SQLCA;
					
					If (SQLCA.SqlCode = 0) AND ( SQLCA.sqlnrows >= 1 ) Then
						Commit;
						
						// okay - time to update the work table
						UPDATE Comcast_Dupe
						SET User_field1 = 'OLD-' + USER_field1,
							 Processed = 1
						where Project_ID = 'COMCAST'
						and Serial_No = :s_itdSerialNo
						USING SQLCA;
						
						
						If (SQLCA.SqlCode = 0) AND ( SQLCA.sqlnrows >= 1 ) Then
							Commit;
							
							l_rtn = dw_multiplemacids.setitem( ll_currow, 'csMAC_ID', (s_mod + s_csMAC_ID) )
							
							// note: apparently putting the single quote mark does not help
							if ( s_csSerialNo_List = '' ) then
								s_csSerialNo_List = s_csSerialNo 
							else
								s_csSerialNo_List = s_csSerialNo_List + ", " + s_csSerialNo
							end if
							
							l_selected_cnt ++
							
							// Also, change status on ITD record from 'E' to 'N' to retry on next process run
							UPDATE Comcast_ITD
							SET Status = 'N'
							WHERE Tran_Nbr = :s_itdTranNbr
							AND Serial_No = :s_itdSerialNo
							USING SQLCA;

							If (SQLCA.SqlCode = 0) AND ( SQLCA.sqlnrows >= 1 ) Then
								Commit;
							Else
								Rollback;
								MessageBox('Info','Update failed on update to Comcast_ITD')
							End if
						Else
							Rollback;
							MessageBox('Info','Update failed on update to Comcast_Dupe')
						End if
					Else
						Rollback;
						MessageBox('Info', 'Update failed - changes for SN: ' +  s_csSerialNo + ' not saved.~r~n Please refresh and try again')
					End if
		
				end if
				
			NEXT  // row
			
			IF l_selected_cnt > 0 THEN MessageBox('INFO', STRING(l_selected_cnt) + ' rows with renamed MACIds successfully processed' )	
			
		END IF // confirmed to process 
	
	END IF // rows found 
	
	cb_refresh.PostEvent(Clicked!)

	return l_selected_cnt

ELSE
	MessageBox('ERROR', 'Critical data error.  Please restart and try again')
	RETURN -1
END IF

end event

type cb_refresh from commandbutton within w_comcast_multiplemacid
string tag = "Refresh the list"
integer x = 2299
integer y = 64
integer width = 512
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Refresh"
end type

event clicked;// retrieve the data
pointer oldpointer
long    lRtn, llRowPos

// retrieve records from work table
oldpointer = SetPointer(HourGlass!)

dw_multiplemacids.Reset( )

if cbx_showall.checked = TRUE then
	lRtn = dw_multiplemacids.Retrieve(1)  // Show all records (unprocessed and processed)
else
	lRtn = dw_multiplemacids.Retrieve(0)  // Show only unprocessed rows
end if

llRowPos = dw_multiplemacids.rowcount( )

IF llRowPos > 0 THEN
	cb_export.Enabled = TRUE
	cb_process_selected.enabled = TRUE
ELSE
	cb_export.Enabled = FALSE
	//cb_process_selected.enabled = FALSE
	
END IF

SetPointer(oldpointer)



end event

type dw_multiplemacids from u_dw_ancestor within w_comcast_multiplemacid
string tag = "If old pallet is still in stock, do not change Mac ID to OLD-.  Investigate which ID is correct."
integer x = 23
integer y = 256
integer width = 4782
integer height = 1116
integer taborder = 40
string dataobject = "d_comcast_multiplemacid"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean hsplitscroll = true
end type

event clicked;call super::clicked;Long	llRowPos,	&
		llRowCount
String lsChangedColumn
Int liProcessed = 0

If Row > 0 Then
	llRowPos = Row
	lsChangedColumn = this.GetColumnName()
	
	dw_multiplemacids.SetRedraw(False)
	
	liProcessed = dw_multiplemacids.GetItemNumber(llRowPos, 'processed')
	if liProcessed = -1 then
		dw_multiplemacids.SetItem(llRowPos, 'indicator', 1)
		messagebox("Warning","Entry already processed " + string(dw_multiplemacids.GetItemNumber(llRowPos, 'indicator')))
	end if

	dw_multiplemacids.SetRedraw(True)

End If

end event

type st_help from statictext within w_comcast_multiplemacid
integer x = 23
integer y = 260
integer width = 3959
integer height = 1116
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "text"
boolean border = true
boolean focusrectangle = false
end type

