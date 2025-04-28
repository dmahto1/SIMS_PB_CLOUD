HA$PBExportHeader$u_dw_import_coty_set_wave.sru
$PBExportComments$Set picking waves for COTY
forward
global type u_dw_import_coty_set_wave from u_dw_import
end type
end forward

global type u_dw_import_coty_set_wave from u_dw_import
integer width = 4384
integer height = 1700
string dataobject = "d_import_coty_set_wave"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_coty_set_wave u_dw_import_coty_set_wave

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsWave, lsTruck, lsTEMP

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case isCurrValColumn
	case "wave"
		goto llogical_truck
	case "logical_truck"
//		goto ldue_qty
		isCurrValColumn = ''
		return ''
End Choose

lsWave = trim(This.GetItemString(al_row, "wave"))
if isnull(lsWave) Then
	This.Setfocus()
	This.SetColumn("wave")
	iscurrvalcolumn = "wave"
	return "'Wave' can not be null!"
End If


llogical_truck:
lsTEMP = This.GetItemString(al_row, "logical_truck")
If isnull(lsTEMP) Then
	This.Setfocus()
	This.SetColumn("logical_truck")
	iscurrvalcolumn = "logical_truck"
	return "'Logical Truck' can not be null!"
End If

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long		llRowCount,	llRowPos, llNew
String	lsWave, lsTruck, lsErrText, lsOrdersSet, lsToday, lsTemp
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

//??? For each Wave, Do we want to update orders for each Truck or string trucks together for 'In' clause???
// Moved below...Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//For each Wave, build the where clause of logical trucks (where Ship_Ref in ('t1', 't2', ...) )
For llRowPos = 1 to llRowCount
	// Shall we string together Shipref's of the same date to build the SQL??
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	lsWave = left(trim(This.GetItemString(llRowPos, "wave")), 8)
	lsTruck = This.GetItemString(llRowPos, "logical_truck") 

	Execute Immediate "Begin Transaction" using SQLCA;
	update delivery_master 
	set cust_order_no = :lsWave
	where project_id = 'coty' and ord_status = 'N' 
	and ship_ref = :lsTruck
	//and ship_ref in (lsTruckList) //build list on Wave change ???
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

if MessageBox("Count Orders", "Count orders affected?", Question!, YesNo!, 1) = 1 then
	select count(do_no) into :lsOrdersSet from delivery_master
	where project_id = 'coty' and ord_status = 'N'
	and cust_order_no = :lsWave; //this assumes only one wave per file...
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

on u_dw_import_coty_set_wave.create
call super::create
end on

on u_dw_import_coty_set_wave.destroy
call super::destroy
end on

