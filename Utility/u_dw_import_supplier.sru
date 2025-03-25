HA$PBExportHeader$u_dw_import_supplier.sru
$PBExportComments$Import Supplier Information
forward
global type u_dw_import_supplier from u_dw_import
end type
end forward

global type u_dw_import_supplier from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_supplier"
end type
global u_dw_import_supplier u_dw_import_supplier

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);		
//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "supplier_code"
		goto lsuppname
	Case "supplier_name"
		goto laddr1
	Case "address1"
		goto laddr2
	Case "address2"
		goto lstate
	Case "state"
		goto lzip
	Case "zip"
		goto lcity
	Case "city"
		goto lcountry
	Case "country"
		goto lContact
	Case "Contact"
		goto ltel
	case "telephone"
		iscurrvalcolumn = ''
		return ''
End Choose

//Validate Supplier Code
If isnull(This.getItemString(al_row,"supplier_code")) Then
	This.Setfocus()
	This.SetColumn("supplier_code")
	iscurrvalcolumn = "supplier_code"
	return "'Supplier Code' can not be null!"
End If

// TAM 2012/09/07 Supp_code length is now 20
//If len(trim(This.getItemString(al_row,"supplier_code"))) > 10 Then
If len(trim(This.getItemString(al_row,"supplier_code"))) > 20 Then
	This.Setfocus()
	This.SetColumn("supplier_code")
	iscurrvalcolumn = "supplier_code"
	return "'Supplier Code' is > 20 characters"
End If
	
lsuppname:
//Validate Supplier Name
If len(trim(This.getItemString(al_row,"supplier_name"))) > 40 Then
	This.Setfocus()
	This.SetColumn("supplier_name")
	iscurrvalcolumn = "supplier_name"
	Return "Supplier Name is > 40 Characters"
End If

laddr1:
//Validate Address 1
If len(trim(This.getItemString(al_row,"address1"))) > 40 Then
	This.Setfocus()
	This.SetColumn("address1")
	iscurrvalcolumn = "address1"
	Return "Address 1 is > 40 Characters"
End If

laddr2:
//Validate Address 2
If len(trim(This.getItemString(al_row,"address2"))) > 40 Then
	This.Setfocus()
	This.SetColumn("address2")
	iscurrvalcolumn = "address2"
	Return "Address 2 is > 40 Characters"
End If
	
lstate:
//Validate State
If len(trim(This.getItemString(al_row,"state"))) > 40 Then
	This.Setfocus()
	This.SetColumn("state")
	iscurrvalcolumn = "state"
	Return "State is > 40 Characters"
End If

lzip:
//Validate Zip
If len(trim(This.getItemString(al_row,"zip"))) > 40 Then
	This.Setfocus()
	This.SetColumn("zip")
	iscurrvalcolumn = "zip"
	Return "Zip Code is > 40 Characters"
End If

lcity:
//Validate City
If len(trim(This.getItemString(al_row,"city"))) > 30 Then
	This.Setfocus()
	This.SetColumn("city")
	iscurrvalcolumn = "city"
	Return "City is > 30 Characters"
End If

lcountry:
//Validate City
If len(trim(This.getItemString(al_row,"country"))) > 30 Then
	This.Setfocus()
	This.SetColumn("country")
	iscurrvalcolumn = "country"
	Return "Country is > 30 Characters"
End If

lcontact:
//Validate contact
If len(trim(This.getItemString(al_row,"contact"))) > 40 Then
	This.Setfocus()
	This.SetColumn("contact")
	iscurrvalcolumn = "contact"
	Return "Contact is > 40 characters"
End If

ltel:
//Validate Telephone
If len(trim(This.getItemString(al_row,"telephone"))) > 20 Then
	This.Setfocus()
	This.SetColumn("telephone")
	iscurrvalcolumn = "telephone"
	Return "Telephone is > 20 characters"
End If

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llUpdate,	&
		llNew
		
String	lsSupplierID,	&
			lsSupplierName,	&
			lsAddr1,				&
			lsAddr2,				&
			lsCity,				&
			lsState,				&
			lsZip,				&
			lsCountry,			&
			lsErrText,			&
			lsTel,				&
			lsContact,			&
			lsSQL
			
Datetime		ldToday

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
//ldToday = Today()

llRowCount = This.RowCount()

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If Upper(gs_project) = 'CHINASIMS'  THEN
	SQLCA.DBParm = "disablebind =0"
End If

//Update or Insert for each Row...
For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
// TAM 2012/09/07 Supp_code length is now 20
//	lsSupplierID = left(trim(This.GetItemString(llRowPos,"supplier_code")),10)
	lsSupplierID = left(trim(This.GetItemString(llRowPos,"supplier_code")),20)
	lsSuppliername = left(trim(This.GetItemString(llRowPos,"supplier_name")),40)
	lsaddr1 = left(trim(This.GetItemString(llRowPos,"address1")),40)
	lsaddr2 = left(trim(This.GetItemString(llRowPos,"address2")),40)
	lscity = left(trim(This.GetItemString(llRowPos,"city")),30)
	lsstate = left(trim(This.GetItemString(llRowPos,"state")),40)
	lszip = left(trim(This.GetItemString(llRowPos,"zip")),40)
	lscountry = left(trim(This.GetItemString(llRowPos,"country")),30)
	lscontact = left(trim(This.GetItemString(llRowPos,"contact")),40)
	lstel = left(trim(This.GetItemString(llRowPos,"telephone")),20)
			
//	//try update first
//	Update supplier Set
//	supp_name = :lssupplierName,
//	address_1 = :lsAddr1,
//	address_2 = :lsAddr2,
//	state = :lsState,
//	zip = :lszip,
//	city = :lsCity,
//	country = :lsCountry,
//	contact_person = :lsContact, 
//	tel = :lsTel, 
//	last_user = :gs_userid,
//	last_update = :ldToday
//	Where supp_code = :lsSupplierID and project_id = :gs_project
//	Using Sqlca;

// 07/01 Pconkl - Build update statement dynamically, based on fields filled in on layout
// so we dont clear out previously entered data if missing from layout

	lsSQL = "Update Supplier Set "
	If lsSupplierName > ' ' Then lsSQl += "Supp_name = '" + lsSupplierName + "', "
	If lsaddr1 > ' ' Then lsSQl += "address_1 = '" + lsaddr1 + "', "
	If lsaddr2 > ' ' Then lsSQl += "address_2 = '" + lsaddr2 + "', "
//	If lsaddr3 > ' ' Then lsSQl += "address_3 = '" + lsaddr3 + "', "
//	If lsaddr4 > ' ' Then lsSQl += "address_4 = '" + lsaddr4 + "', "
	If lsCity > ' ' Then lsSQl += "City = '" + lsCity + "', "
	If lsState > ' ' Then lsSQl += "state = '" + lsstate + "', "
	If lsZip > ' ' Then lsSQl += "Zip = '" + lsZip + "', "
	If lsCountry > ' ' Then lsSQl += "country = '" + lsCountry + "', "
	If lsTel > ' ' Then lsSQl += "tel = '" + lstel + "', "
//	If lsFax > ' ' Then lsSQl += "fax = '" + lsfax + "', "
	If lsContact > ' ' Then lsSQl += "contact_person = '" + lscontact + "', "
	lsSQl += "last_user = '" + gs_userid + "', last_update = '" + string(today(),'mm-dd-yy hh:mm:ss') + "'" /*last update*/
	lsSQl += " Where supp_code = '" + lsSupplierID + "' and project_id = '" + gs_project + "'"

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
	
	If Sqlca.sqlnrows <> 1 Then /*Insert*/
	
		Insert Into supplier (project_id,supp_code,supp_name,address_1,address_2,state,zip,city,country,contact_person,tel,last_user,last_update) values (:gs_project,:lsSupplierID,:lsSupplierName,:lsAddr1,:lsAddr2,:lsState,:lsZip,:lsCity,:lsCountry,:lsContact, :lsTel,:gs_userid,:ldToday)
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

on u_dw_import_supplier.create
call super::create
end on

on u_dw_import_supplier.destroy
call super::destroy
end on

