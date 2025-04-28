$PBExportHeader$u_dw_import_locations.sru
$PBExportComments$Import Locations
forward
global type u_dw_import_locations from u_dw_import
end type
end forward

global type u_dw_import_locations from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_locations"
end type
global u_dw_import_locations u_dw_import_locations

forward prototypes
public function integer wf_save ()
public function string wf_validate (long al_row)
end prototypes

public function integer wf_save ();Long		llRowCount,	&
			llRowPos,	&
			llUpdate,	&
			llNew
		
Decimal	ldLength,	&
			ldWidth,		&
			ldHeight,	&
			ldCapacity,	&
			ldPriority, &
			ld_picking_seq, &
			ldcbm // Dinesh - 04262022- DE25678-SIMS - Locations' CBM not updated after upload
		
String	lsWarehouse,	&
			lsLocation,		&
			lsType,			&
			lsErrText,		&
			lsSQL,         &
			lsSKU_reserved, &
			ls_zone_id, &
			lsloc_available_ind, & 
			ls_som,ls_som1,ls_prewh,&
			ls_uf1,ls_uf2,ls_uf3 //22-Dec-2014 :Madhu Added UF1,UF2 and UF3.

String		ls_unique_sku_ind	// LTK 20150812

//06-Mar-2013 :Madhu - Added - lsloc_available_ind
//12-Aug-2013 :Madhu -Added	 - ls_som,ls_som1,ls_prewh

string lsToday
datetime ldtToday

llRowCount = This.RowCount()

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( gs_default_wh ) 
lsToday = string( ldtToday, 'mm/dd/yyyy hh:mm:ss')

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =0"
End If


//Update or Insert for each Row...
For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsWarehouse = left(trim(This.GetItemString(llRowPos,"warehouse")),10)

	// BAD! BAD! BAD!
	// pvh 02.15.06 - gmt
	//ldtToday = f_getLocalWorldTime( lsWarehouse ) 
	//lsToday = string( ldtToday, 'mm/dd/yyyy hh:mm:ss')


	lsLocation = left(trim(This.GetItemString(llRowPos,"location")),10)
	lsType = left(trim(This.GetItemString(llRowPos,"type")),1)
	ldLength = dec(left(trim(This.GetItemString(llRowPos,"length")),6))
	ldwidth = dec(left(trim(This.GetItemString(llRowPos,"width")),6))
	ldheight = dec(left(trim(This.GetItemString(llRowPos,"height")),6))
	ldcbm= dec(ldLength*ldwidth*ldheight)               // Dinesh - 04262022- DE25678- added CBM SIMS - Locations' CBM not updated after upload
	ldcapacity = dec(left(trim(This.GetItemString(llRowPos,"capacity")),11))
	ldPriority = dec(left(trim(This.GetItemString(llRowPos,"priority")),2))
	ld_picking_seq = dec(left(trim(This.GetItemString(llRowPos,"picking_seq")),6))
	ls_zone_id = left(trim(This.GetItemString(llRowPos,"zone_id")),5)
	lsSKU_reserved = left(trim(This.GetItemString(llRowPos,"sku_reserved")),50)
	lsloc_available_ind = left(trim(This.GetItemString(llRowPos,"Location_Available_Ind")),1) //06-Mar-2013 :Madhu - Added
	//12-Aug-2013 :Madhu -Added Standard_of_Measure column -START
	ls_som =left(trim(This.GetITemstring(llRowPos,"Standard_Of_Measure")),1)
	ls_uf1 =left(trim(This.GetItemString(llRowPos,"User_Field1")),20) //22-Dec-2014 :Madhu Added UF1,UF2 and UF3.
	ls_uf2 =left(trim(This.GetItemString(llRowPos,"User_Field2")),40) //22-Dec-2014 :Madhu Added UF1,UF2 and UF3.
	ls_uf3 =left(trim(This.GetItemString(llRowPos,"User_Field3")),60) //22-Dec-2014 :Madhu Added UF1,UF2 and UF3.
	ls_unique_sku_ind = left(trim(This.GetItemString(llRowPos,"Unique_SKU_Ind")),1)

	
	IF lsWarehouse <> ls_prewh THEN
		select Standard_Of_Measure into :ls_som1
		from Project_Warehouse
		where wh_code =:lsWarehouse
		using sqlca;
	END IF

	IF (IsNull(ls_som) OR (trim(ls_som) ='')) THEN		ls_som =ls_som1

	//12-Aug-2013 :Madhu -added Standard_of_Measure column -END

// 07/01 Pconkl - Build update statement dynamically - only include fields with data
//						so we dont clear any previously entered data not included in this import

	lsSQL = "Update location Set "
	If lsType > ' ' Then lsSQL += " l_type = '" + lsType + "', "
	IF ls_zone_id  > ' ' Then lsSQL += " zone_id = '" + ls_zone_id + "', "
	If ldLength > 0 Then lsSql += " length = " + String(ldLength) + ", "
	If ldWidth > 0 Then lsSql += " Width = " + String(ldWidth) + ", "
	If ldHeight > 0 Then lsSql += " Height = " + String(ldHeight) + ", "
	If ldcbm > 0 Then lsSql += " CBM = " + String(ldcbm) + ", "  // Dinesh - 04262022- DE25678-SIMS - Locations' CBM not updated after upload
	If ldCapacity > 0 Then lsSql += " weight_capacity = " + String(ldCapacity) + ", "
	If ldpriority > 0 Then lsSql += " priority = " + String(ldpriority) + ", "
	If ld_picking_seq > 0 Then lsSql += " picking_seq = " + String(ld_picking_seq) + ", "
	If lssku_reserved > ' ' Then lsSql += " sku_reserved = '" + lssku_reserved + "', "
	If lsloc_available_ind > ' ' Then lsSql += " Location_Available_Ind = '" + lsloc_available_ind + "', "  //06-Mar-2013 :Madhu -Added
	If ls_som >' ' Then lsSql += "Standard_Of_Measure ='"+ trim(ls_som)+"'," //12-Aug-2013 :Madhu -Added
	If ls_uf1 >' ' Then lsSql += "User_Field1='"+ trim(ls_uf1)+"'," //22-Dec-2014 :Madhu Added UF1,UF2 and UF3.
	If ls_uf2 >' ' Then lsSql += "User_Field2='"+ trim(ls_uf2)+"'," //22-Dec-2014 :Madhu Added UF1,UF2 and UF3.
	If ls_uf3 >' ' Then lsSql += "User_Field3='"+ trim(ls_uf3)+"'," //22-Dec-2014 :Madhu Added UF1,UF2 and UF3.
	if ls_unique_sku_ind > ' ' Then lsSql += " Unique_SKU_Ind = '" + ls_unique_sku_ind + "', "  // LTK 20150812
	lsSQl += "last_user = '" + gs_userid + "', last_update = '" + lsToday + "'" /*last update*/
	lsSQl += " Where wh_code = '" + lsWarehouse + "' and l_code = '" + lslocation + "'" /*Where*/

		
	Execute Immediate :LSSQL Using SQLCA;
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		
		If Upper(gs_project) = 'CHINASIMS'  THEN
			 SQLCA.DBParm = "disablebind =1"
		End If		
		
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If

	
	If Sqlca.sqlnrows <> 1 Then /*Insert*//* 06-MAR-2013 :Madhu - Added  'Location_Available_Indicator' column*/
	/*12-Aug-2013 :Madhu -Added 'Standard_Of_Measure' column*/
	//22-Dec-2014 :Madhu Added UF1,UF2 and UF3.
	
		Insert Into location (wh_code,l_code,l_type,length,width,height,weight_capacity,priority,picking_seq,sku_reserved,Location_Available_Ind,&
		last_user,last_update,Standard_Of_Measure,zone_id,user_field1,user_field2,user_field3, Unique_SKU_Ind,CBM) values (:lsWarehouse,:lsLocation,:lsType,:ldLength,:ldWidth,&
		:ldHeight,:ldCapacity,:ldPriority,:ld_picking_seq,:lssku_reserved,:lsloc_available_ind,:gs_userid,:ldtToday,:ls_som,:ls_zone_id,:ls_uf1,:ls_uf2,:ls_uf3,:ls_unique_sku_ind,:ldcbm) // Dinesh - 04262022- DE25678- added CBM SIMS - Locations' CBM not updated after upload
		Using SQLCA;
	
			If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			
			If Upper(gs_project) = 'CHINASIMS'  THEN
				 SQLCA.DBParm = "disablebind =1"
			End If
						
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		Else
			llnew ++
		End If
	Else /*update*/
		llupdate ++
	End If
	
	ls_prewh =lsWarehouse //12-Aug-2013 :Madhu -Added
Next

If Upper(gs_project) = 'CHINASIMS'  THEN
	SQLCA.DBParm = "disablebind =1"
End If


Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "~r~rRecords Added: " + String(llNew))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

public function string wf_validate (long al_row);String	lswarehouse,	&
			lsType, &
			lssku_reserved
			
Long llCount

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "warehouse"
		goto lloc
	Case "location"
		goto ltype
	Case "type"
		goto llength
	Case "length"
		goto lwidth
	Case "width"
		goto lheight
	Case "height"
		goto lcapacity
	Case "capacity"
		goto lpriority
	case "priority"
		iscurrvalcolumn = ''
		return ''
	case "picking_seq"
		goto lpicking_seq
	case "zone_id"
		goto lzone_id		
	case "sku_reserved"
		goto lsku_reserved		
End Choose

//Validate warehouse
If isnull(This.getItemString(al_row,"warehouse")) Then
	This.Setfocus()
	This.SetColumn("warehouse")
	iscurrvalcolumn = "warehouse"
	return "'Warehouse' can not be null!"
End If

If len(trim(This.getItemString(al_row,"warehouse"))) > 10 Then
	This.Setfocus()
	This.SetColumn("warehouse")
	iscurrvalcolumn = "warehouse"
	return "'Warehouse' is > 10 characters"
End If

lsWarehouse = This.getItemString(al_row,"warehouse")
Select Count(*)
Into :llCount
from Warehouse
Where wh_code = :lsWarehouse
Using SQLCA;

If llCount <=0 Then
	This.Setfocus()
	This.SetColumn("warehouse")
	iscurrvalcolumn = "warehouse"
	return "Warehouse Code is not Valid"
End If

lloc:
//Location
If isnull(This.getItemString(al_row,"location")) Then
	This.Setfocus()
	This.SetColumn("location")
	iscurrvalcolumn = "location"
	return "'Location' can not be null!"
End If

If len(trim(This.getItemString(al_row,"location"))) > 10 Then
	This.Setfocus()
	This.SetColumn("location")
	iscurrvalcolumn = "location"
	return "'Location' is > 10 characters"
End If
	
ltype:
//Location Type
If len(trim(This.getItemString(al_row,"type"))) > 1 Then
	This.Setfocus()
	This.SetColumn("type")
	iscurrvalcolumn = "type"
	Return "Location Type is > 1 Character"
End If

lsType = This.getItemString(al_row,"type")
Select Count(*)
Into :llCount
from location_type
Where l_type = :lstype
Using SQLCA;

If llCount <=0 Then
	This.Setfocus()
	This.SetColumn("type")
	iscurrvalcolumn = "type"
	Return "Location Type is Invalid"
End If

llength:
//Length
If not isnumber(This.getItemString(al_row,"length")) Then
	This.Setfocus()
	This.SetColumn("length")
	iscurrvalcolumn = "length"
	Return "length Must be Numeric!"
End If

If len(trim(This.getItemString(al_row,"length"))) > 6 Then
	This.Setfocus()
	This.SetColumn("length")
	iscurrvalcolumn = "length"
	Return "length is > 6 digits"
End If

lwidth:
//Width
If not isnumber(This.getItemString(al_row,"width")) Then
	This.Setfocus()
	This.SetColumn("width")
	iscurrvalcolumn = "width"
	Return "Width Must be Numeric!"
End If

If len(trim(This.getItemString(al_row,"width"))) > 6 Then
	This.Setfocus()
	This.SetColumn("width")
	iscurrvalcolumn = "width"
	Return "Width is > 6 digits"
End If

lheight:
//height
If not isnumber(This.getItemString(al_row,"height")) Then
	This.Setfocus()
	This.SetColumn("height")
	iscurrvalcolumn = "height"
	Return "Height Must be Numeric!"
End If

If len(trim(This.getItemString(al_row,"height"))) > 6 Then
	This.Setfocus()
	This.SetColumn("height")
	iscurrvalcolumn = "height"
	Return "Height is > 6 digits"
End If

lcapacity:
//capacity
If not isnumber(This.getItemString(al_row,"capacity")) Then
	This.Setfocus()
	This.SetColumn("capacity")
	iscurrvalcolumn = "capacity"
	Return "Weight Capacity Must be Numeric!"
End If

If len(trim(This.getItemString(al_row,"capacity"))) > 9 Then
	This.Setfocus()
	This.SetColumn("capacity")
	iscurrvalcolumn = "capacity"
	Return "Capacity is > 9 digits"
End If

//prioity
lPriority:
If not isnumber(This.getItemString(al_row,"priority")) Then
	This.Setfocus()
	This.SetColumn("priority")
	iscurrvalcolumn = "priority"
	Return "Priority Must be Numeric!"
End If

If len(trim(This.getItemString(al_row,"priority"))) > 9 Then
	This.Setfocus()
	This.SetColumn("priority")
	iscurrvalcolumn = "piority"
	Return "Priority is > 2 digits"
End If


lpicking_seq:
If not isnumber(This.getItemString(al_row,"picking_seq")) Then
	This.Setfocus()
	This.SetColumn("picking_seq")
	iscurrvalcolumn = "picking_seq"
	Return "picking Seq Must be Numeric!"
End If

If len(trim(This.getItemString(al_row,"picking_seq"))) > 6 Then
	This.Setfocus()
	This.SetColumn("picking_seq")
	iscurrvalcolumn = "picking_seq"
	Return "picking_seq is > 6 digits"
End If

lzone_id:
If len(trim(This.getItemString(al_row,"zone_id"))) > 5 Then
	This.Setfocus()
	This.SetColumn("zone_id")
	iscurrvalcolumn = "zone_id"
	Return "zone_id is > 5 digits"
End If

lsku_reserved:
If len(trim(This.getItemString(al_row,"sku_reserved"))) > 50 Then
	This.Setfocus()
	This.SetColumn("sku_reserved")
	iscurrvalcolumn = "sku_reserved"
	Return "sku_reserved is > 50 digits"
End If

lssku_reserved = This.getItemString(al_row,"sku_reserved")
if isnull(lssku_reserved) or lssku_reserved = '' Then
Else
	Select Count(*)
	Into :llCount
	from Item_master
	Where sku = :lssku_reserved
	Using SQLCA;

	If llCount <=0 Then
		This.Setfocus()
		This.SetColumn("sku_reserved")
		iscurrvalcolumn = "sku_reserved"
		Return "SKU Reserved is Invalid"
	End If
End If


iscurrvalcolumn = ''
return ''

end function

on u_dw_import_locations.create
call super::create
end on

on u_dw_import_locations.destroy
call super::destroy
end on

