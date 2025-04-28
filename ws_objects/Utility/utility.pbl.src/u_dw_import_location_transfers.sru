$PBExportHeader$u_dw_import_location_transfers.sru
$PBExportComments$Import Location Transfers
forward
global type u_dw_import_location_transfers from u_dw_import
end type
end forward

global type u_dw_import_location_transfers from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_location_transfers"
end type
global u_dw_import_location_transfers u_dw_import_location_transfers

forward prototypes
public function integer wf_save ()
public function string wf_validate (long al_row)
end prototypes

public function integer wf_save ();Long llRowCount, llRowPos, llUpdate, llNew
		
String lsWH, lsFromLoc, lsToLoc, lsSql, lsErrText, lsToday, lsSaveFile
datetime ldtToday

llRowCount = This.RowCount()

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( gs_default_wh ) 
lsToday = string( ldtToday, 'mm/dd/yyyy hh:mm:ss')

//Grab the file, in case we're going to create a transfer for the affected records
//lsSaveFile = w_import.isImportFile

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//Update or Insert for each Row...
For llRowPos = 1 to llRowCount
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsWH = left(trim(This.GetItemString(llRowPos, "warehouse")), 10)

	// BAD! BAD! BAD!
	// pvh 02.15.06 - gmt
	//ldtToday = f_getLocalWorldTime( lsWarehouse ) 
	//lsToday = string( ldtToday, 'mm/dd/yyyy hh:mm:ss')

	lsFromLoc = left(trim(This.GetItemString(llRowPos, "fromlocation")), 10)
	lsToLoc = left(trim(This.GetItemString(llRowPos, "tolocation")), 10)


// 07/01 Pconkl - Build update statement dynamically - only include fields with data
//						so we dont clear any previously entered data not included in this import

	lsSQL = "Update content Set "
	If lsToLoc > ' ' Then lsSQL += " l_code = '" + lsToLoc + "', "
	lsSQl += "last_user = '" + gs_userid + "', last_update = '" + lsToday + "'" /*last update*/
	lsSQl += " Where wh_code = '" + lsWH + "' and l_code = '" + lsFromLoc + "'"

	Execute Immediate :LSSQL Using SQLCA;
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If

	llNew = Sqlca.sqlnrows 
	If llNew > 0 Then 
		llUpdate = llUpdate + llNew
	Else /*update*/
		Messagebox("Import", "No Inventory records to update for location " + lsFromLoc)
	/*
		Insert Into location (wh_code,l_code,l_type,length,width,height,weight_capacity,priority,picking_seq,sku_reserved,&
		last_user,last_update) values (:lsWarehouse,:lsLocation,:lsType,:ldLength,:ldWidth,&
		:ldHeight,:ldCapacity,:ldPriority,:ld_picking_seq,:lssku_reserved,:gs_userid,:ldtToday)
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
	*/
	End If
	
Next

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

//MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "~r~rRecords Added: " + String(llNew))
MessageBox("Import", "~rInventory Records Updated: " + String(llUpdate))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

public function string wf_validate (long al_row);String	lsWH, lsFromLoc, lsToLoc
			
Long llCount

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "warehouse"
		goto lFrom
	Case "fromlocation"
		goto lTo
	Case "tolocation"
		iscurrvalcolumn = ''
		return ''
End Choose

//Validate warehouse
If isnull(This.getItemString(al_row, "warehouse")) Then
	This.Setfocus()
	This.SetColumn("warehouse")
//	iscurrvalcolumn = "warehouse"
	return "'Warehouse' can not be null!"
End If

If len(trim(This.getItemString(al_row, "warehouse"))) > 10 Then
	This.Setfocus()
	This.SetColumn("warehouse")
//	iscurrvalcolumn = "warehouse"
	return "'Warehouse' is > 10 characters"
End If

lsWH = This.getItemString(al_row, "warehouse")
//Select Count(*) Into :llCount from Warehouse Where wh_code = :lsWH
Select Count(*) Into :llCount 
from Project_Warehouse 
Where project_id = :gs_Project
and wh_code = :lsWH
Using SQLCA;

If llCount <=0 Then
	This.Setfocus()
	This.SetColumn("warehouse")
//	iscurrvalcolumn = "warehouse"
	return "Warehouse Code is not Valid"
End If

lFrom:
//From Location
If isnull(This.getItemString(al_row, "fromlocation")) Then
	This.Setfocus()
	This.SetColumn("fromlocation")
//	iscurrvalcolumn = "fromlocation"
	return "'FROM Location' can not be null!"
End If

lsFromLoc = This.getItemString(al_row, "fromlocation")
If len(lsFromLoc) > 10 Then
	This.Setfocus()
	This.SetColumn("fromlocation")
//	iscurrvalcolumn = "fromlocation"
	return "'FROM Location' is > 10 characters"
End If
	
Select Count(*)
Into :llCount
from location
Where wh_code = :lsWH
and l_code = :lsFromLoc
Using SQLCA;

If llCount <=0 Then
	This.Setfocus()
	This.SetColumn("fromlocation")
//	iscurrvalcolumn = "fromlocation"
	return "FROM Location Code is not Valid"
End If

lTo:
//TO Location
If isnull(This.getItemString(al_row, "tolocation")) Then
	This.Setfocus()
	This.SetColumn("tolocation")
//	iscurrvalcolumn = "tolocation"
	return "'TO Location' can not be null!"
End If

lsToLoc = This.getItemString(al_row, "tolocation")
If len(lsToLoc) > 10 Then
	This.Setfocus()
	This.SetColumn("tolocation")
//	iscurrvalcolumn = "tolocation"
	return "'TO Location' is > 10 characters"
End If

Select Count(*)
Into :llCount
from location
Where wh_code = :lsWH
and l_code = :lsToLoc
Using SQLCA;

If llCount <=0 Then
	This.Setfocus()
	This.SetColumn("tolocation")
//	iscurrvalcolumn = "tolocation"
	return "TO Location Code is not Valid"
End If

iscurrvalcolumn = ''
return ''

end function

on u_dw_import_location_transfers.create
call super::create
end on

on u_dw_import_location_transfers.destroy
call super::destroy
end on

