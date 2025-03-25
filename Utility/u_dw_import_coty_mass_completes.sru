HA$PBExportHeader$u_dw_import_coty_mass_completes.sru
$PBExportComments$Set Outbound orders to complete for COTY
forward
global type u_dw_import_coty_mass_completes from u_dw_import
end type
end forward

global type u_dw_import_coty_mass_completes from u_dw_import
integer width = 4384
integer height = 1700
string dataobject = "d_import_coty_mass_completes"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_coty_mass_completes u_dw_import_coty_mass_completes

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsShipRef, lsTEMP
string lsMon, lsDay, lsYear
//long		llCount

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case isCurrValColumn
	case "ship_ref"
		goto lcomplete_date
	case "complete_date"
//		goto ldue_qty
		isCurrValColumn = ''
		return ''
End Choose

lsShipRef = trim(This.GetItemString(al_row, "ship_ref"))
if isnull(lsShipRef) Then
	This.Setfocus()
	This.SetColumn("ship_ref")
	iscurrvalcolumn = "ship_ref"
	return "'Ship Ref' (Logical Truck) can not be null!"
End If


lcomplete_date:
lsTEMP = This.GetItemString(al_row, "complete_date")
If not isnull(lsTEMP) then
	//dd-mmm-yy - This isn't being interpreted as a date, so...
	if len(lsTemp) <> 9 then
		This.Setfocus()
		This.SetColumn("Complete_date")
		iscurrvalcolumn = "complete_date"
		return "Unexpected format: 'Complete Date' must be dd-mmm-yy!"
	end if
	lsDay = left(lsTemp, 2)
	lsMon = mid(lsTemp, 4, 3)
	lsYear = right(lsTemp,2)
	lsTemp = lsMon + " " + lsDay + ", " + lsYear
end if
If isnull(lsTEMP) or not isdate(lsTEMP) Then
	This.Setfocus()
	This.SetColumn("Complete_date")
	iscurrvalcolumn = "complete_date"
	return "'Complete Date' can not be null and must be a date!"
End If

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long		llRowCount,	llRowPos, llNew
String	lsShipRef, lsCompleteDate, lsErrText, lsOrdersSet, lsToday, lsTemp
Datetime		ldToday
string lsDay, lsTime

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
//ldToday = Today()
lsToday = string(ldToday)
lsDay = string(date(ldToday))
lsTime = string(time(ldToday))

llRowCount = This.RowCount()
//this.SetSort("Ship_ref, complete_date")
//this.sort()

//llNew = 0

SetPointer(Hourglass!)

//??? Do we want to do all of this in a single transaction or multiple???
// Moved below...Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//For each Ship_Ref, update all orders that are in 'I' status....
lsTemp = 'Set to Complete at ' + lsTime + ' on ' + lsDay 
For llRowPos = 1 to llRowCount
	// Shall we string together Shipref's of the same date to build the SQL??
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	lsShipRef = left(trim(This.GetItemString(llRowPos, "ship_ref")), 40)
//	lsCompleteDate = left(trim(This.GetItemString(llRowPos, "complete_date")), 0) // dd-mmm-yy
//messagebox("TEMPO: " +string(llRowPos), lsCompleteDate)
	lsCompleteDate = This.GetItemString(llRowPos, "complete_date") // dd-mmm-yy
//messagebox("TEMPO: " +string(llRowPos), lsCompleteDate)

	Execute Immediate "Begin Transaction" using SQLCA;
	update delivery_master 
	set ord_status = 'C', 
	complete_date = :lsCompleteDate, 
	user_field15 = :lsTemp
//	user_field15 = 'Set to Complete at ' + :ldToday
	where project_id = 'coty' and ord_status = 'I' 
	and ship_ref = :lsShipRef
	Using SQLCA;

	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	Else
		llnew ++
	End If
	Execute Immediate "COMMIT" using SQLCA;
	If sqlca.sqlcode <> 0 Then
		MessageBox("Import","Record " + string(llnew) + ": Unable to Commit changes! No changes made to Database!")
		Return -1
	End If
		
Next

if MessageBox("COUNT Orders", "Count orders affected?", Question!, YesNo!, 1) = 1 then
	select count(do_no) into :lsOrdersSet from delivery_master
	where project_id = 'coty' and ord_status = 'C' 
	and user_field15 like :lsTemp;
	//and user_field15 like '% 03/14%';
	//group by right(user_field15, 10)
	if lsOrdersSet = '1' then
		MessageBox("Import", string(llNew) + " Logical Trucks processed. " + lsOrdersSet + " order affected.")
	else
		MessageBox("Import", string(llNew) + " Logical Trucks processed. " + lsOrdersSet + " orders affected.")
	end if
else
	MessageBox("Import", string(llNew) + " Logical Trucks processed.")
end if

w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_coty_mass_completes.create
call super::create
end on

on u_dw_import_coty_mass_completes.destroy
call super::destroy
end on

