HA$PBExportHeader$u_dw_ancestor.sru
$PBExportComments$Ancestor for datawindow objects
forward
global type u_dw_ancestor from datawindow
end type
end forward

global type u_dw_ancestor from datawindow
integer width = 494
integer height = 360
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_retrieve ( )
event process_enter pbm_dwnprocessenter
event ue_insert ( )
event ue_delete ( )
event type integer ue_copy ( )
event ue_save ( )
event type long ue_post_dberror ( long sqldbcode,  string sqlerrtext,  string sqlsyntax,  dwbuffer buffer,  long row )
event ue_postitemchanged ( long row,  dwobject dwo )
event ue_tabout pbm_dwntabout
event ue_resize ( )
end type
global u_dw_ancestor u_dw_ancestor

type variables
PUBLIC Boolean ib_error
PUBLIC  long il_curr
PUBLIC Boolean ib_filter

// pvh 10/27/05
integer iiOriginalX
integer iiOriginalY
integer iiOriginalWidth
integer iiOriginalHeight



end variables

forward prototypes
public subroutine setoriginalposition ()
public subroutine setoriginalx (integer _value)
public subroutine setoriginaly (integer _value)
public subroutine setoriginalwidth (integer _value)
public subroutine setoriginalheight (integer _value)
public function integer getoriginalx ()
public function integer getoriginaly ()
public function integer getoriginalwidth ()
public function integer getoriginalheight ()
end prototypes

event type long ue_post_dberror(long sqldbcode, string sqlerrtext, string sqlsyntax, dwbuffer buffer, long row);String ls_buffer_work,ls_message, lsVersion
ulong lul_name_size = 32
String	ls_machine_name = Space (32)
DateTime	ldtNow
long	llRC,ll_idno
String  lsDataWindow, lsDataObject, lsParentObject, lsBuffer, lsSystemNo
Long llRowNumber

//	Prepare buffer work info

if buffer                = Primary! 	then	
   ls_buffer_work = "Primary (main one you see)"
elseif buffer	         = Filter!      then
   ls_buffer_work = "Filter (select menu option View/Filter to see it)"
elseif	buffer       = Delete!    then
   ls_buffer_work = "Delete (some row you were trying to delete)"
end if
							
ls_message =  "DATABASE ERROR CODE:  "                 + string(sqldbcode)         + ", " + &
                       "DATABASE ERROR MESSAGE: "	       + sqlerrtext                      + ", " + &
                       "WHERE ERROR OCCURRED:  "                                                           + ", " + &
                          "dberror event of "                                                                           + ", " + &
                          "datawindow "                                         + this.ClassName()          + ", " + &
                          "(DataObject is "                                       + this.DataObject              + "), " + &
                          "on row # "                                               + string(row)                    + ", " + &
                          "in this buffer - "                                       + ls_buffer_work             	+ ", " + &
                          "which is on "                                           + parent.ClassName()       + ", " 

//TimA 08/13/15 new varables to catch
lsDataWindow =  This.ClassName( )
lsDataObject = This.DataObject
lsParentObject = Parent.ClassName( )
llRowNumber = row
lsBuffer = ls_buffer_work

If gs_System_No = '' then
	SetNull(lsSystemNo )
Else
	lsSystemNo = gs_System_No
End if

CHOOSE CASE sqldbcode
	CASE -3
		Messagebox("DB Error","The field(s) on this record that you have modified have been modified by another user.~r~rRe-retrieve this record to see the latest changes.",StopSign!)
	CASE 2627
		Messagebox("DB Error","Attempt to insert duplicate record please check",StopSign!)
	Case 64, -1, 999, 10054 /* 12/12 - PCONKL - If not connected, try and re-connect*/
		
		If Messagebox("DB Error","Connection to the database has been lost. Would you like to attempt to reconnect?~r~rCLICKING NO WILL CLOSE SIMS AND YOU WILL LOSE ANY UNSAVED CHANGES!",Exclamation!,YesNo!,1) = 1 then
			
			llRC = g.of_Connect_to_db()
			SetPointer (Arrow!)

			IF llRC <> 0 THEN
				
				MessageBox ("DB Error", "Unable to reconnect: " + String(llRC) + "/" + sqlca.sqlerrtext)
				Halt close
				Return -1
				
			Else
				
				Messagebox("DB Error", "Reconnection sucessfull!")
				
			END IF

			gb_sqlca_connected = TRUE

		Else
			Halt close
		End If
		
	CASE ELSE
		
		// 12/12 - PCONKL - Instead of displaying the errror, write it to the log table and display a generic error msg
		g.GetComputerNameA (ls_machine_name, lul_name_size)
		lsVersion = f_get_Version() 
		//TimA 09/22/15 changed for local time of the computer to GMT time to match method trace calls.
		//GMT right now.  
		SELECT GETDATE() INTO :ldtNow FROM Websphere_Settings ;		
		//ldtNow = DateTime(today(),Now())

		Execute Immediate "Begin Transaction" using SQLCA;

		Insert Into Database_error_log (Project_ID, UserID, Machine_Name, Sims_Version,db_error_Code,db_error_msg,db_sql_Syntax,error_timeStamp, System_No, DataWindow, DataObject, ParentObject, RowNumber, Buffer )
				Values	(:gs_project, :gs_userid, :ls_machine_name, :lsVersion,:sqldbcode,:ls_Message,:sqlsyntax,:ldtNow, :lsSystemNo, :lsDataWindow, :lsDataObject, :lsParentObject, :llRowNumber, :lsBuffer )
		Using	SQLCA;

		Execute Immediate "COMMIT" using SQLCA;
		
		/* Sarun 03122013 to display id_no in messagebox */
		
		select top 1 ID_No into :ll_idno from Database_Error_Log  order by ID_No desc ;
		
		Messagebox("Database Error",String(ll_idno) + " : A database error has occurred and has been logged. Please contact support for additional details if necessary.",StopSign!)
		
		
END CHOOSE
this.Setfocus()
this.scrolltorow(row)
ib_error = True

Return 1
end event

event ue_resize();// ue_resize()

end event

public subroutine setoriginalposition ();// setOriginalPostion()

setOriginalX( this.x )
setOriginalY( this.y )
setOriginalWidth( this.width )
setOriginalHeight( this.height )

end subroutine

public subroutine setoriginalx (integer _value);// setOriginalX( int _value )
iiOriginalX = _value

end subroutine

public subroutine setoriginaly (integer _value);// setOriginalY( int _value )
iiOriginalY = _value

end subroutine

public subroutine setoriginalwidth (integer _value);// setOriginalWidth( int _value )
iiOriginalWidth = _value

end subroutine

public subroutine setoriginalheight (integer _value);// setOriginalHeight( int _value )
iiOriginalHeight = _value

end subroutine

public function integer getoriginalx ();// integer = getOriginalX()
return iiOriginalX

end function

public function integer getoriginaly ();// integer = getOriginalY()
return iiOriginalY

end function

public function integer getoriginalwidth ();// integer = getOriginalWidth()
return iiOriginalWidth

end function

public function integer getoriginalheight ();// integer = getOriginalHeight()
return iiOriginalHeight
end function

event constructor;This.SetTransObject(Sqlca)
//IF g.ib_label_access THEN g.POST of_lable_insert(this)
g.of_check_label(this) 

g.of_set_dw_columns(this)

setOriginalPosition()


end event

event dberror;POST EVENT ue_post_dberror(sqldbcode,sqlerrtext,sqlsyntax,buffer,row)
Return 1

end event

event clicked;il_curr=row
IF ib_filter and ISVALID(m_simple_edit) THEN 	m_simple_edit.m_record.m_filter.Enable()

end event

event itemfocuschanged;il_curr=row
if lower(this.tag) = 'microhelp' THEN g.of_setmicrohelp(dwo)

end event

event losefocus;if lower(this.tag) = 'microhelp' THEN g.of_setmicrohelp()

end event

event retrieveend;if lower(this.tag) = 'microhelp' THEN  g.Post of_setmicrohelp()
end event

event getfocus;IF ib_filter and  ISVALID(m_simple_edit) THEN 	m_simple_edit.m_record.m_filter.Enable()
//ELSE
//	m_simple_edit.m_record.m_filter.Disable()
//END IF	
end event

on u_dw_ancestor.create
end on

on u_dw_ancestor.destroy
end on

event itemchanged;Post Event ue_postitemchanged(row,dwo)
end event

