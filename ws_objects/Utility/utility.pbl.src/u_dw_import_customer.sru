$PBExportHeader$u_dw_import_customer.sru
$PBExportComments$Import Customer Information
forward
global type u_dw_import_customer from u_dw_import
end type
end forward

global type u_dw_import_customer from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_customer"
end type
global u_dw_import_customer u_dw_import_customer

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);		
//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "customer_code"
		goto lcustname
	Case "customer_name"
		goto laddr1
	case "address1"
		goto laddr2
	case "address2"
		goto lcity
	Case "city"
		goto lstate
	Case "state"
		goto lzip
	Case "zip"
		goto lcountry
	case "country"
		goto ltel
	Case "telephone"
		goto lfax
	case "fax"
		goto lcontact
	case "contact"
		goto lprice
	case "price_class"
		goto ltype
	case "priority"
		goto lpriority
	case "discount"
		goto ldiscount
	case "customer_type"
		iscurrvalcolumn = ''
		return ''
End Choose

//Validate Customer Code
If isnull(This.getItemString(al_row,"customer_code")) Then
	This.Setfocus()
	This.SetColumn("customer_code")
	iscurrvalcolumn = "customer_code"
	return "'Customer Code' can not be null!"
End If

If len(trim(This.getItemString(al_row,"customer_code"))) > 20 Then
	This.Setfocus()
	This.SetColumn("customer_code")
	iscurrvalcolumn = "customer_code"
	return "'Customer Code' is > 20 characters"
End If
	
lcustname:
//Validate Customer Name
If len(trim(This.getItemString(al_row,"customer_name"))) > 60 Then
	This.Setfocus()
	This.SetColumn("customer_name")
	iscurrvalcolumn = "customer_name"
	Return "Customer Name is > 50 Characters"
End If
	
laddr1:
//Validate Address 1
If len(trim(This.getItemString(al_row,"address1"))) > 60 Then
	This.Setfocus()
	This.SetColumn("address1")
	iscurrvalcolumn = "address1"
	Return "Address 1 is > 60 characters"
End If

laddr2:
//Validate Address 2
If len(trim(This.getItemString(al_row,"address2"))) > 60 Then
	This.Setfocus()
	This.SetColumn("address2")
	iscurrvalcolumn = "address2"
	Return "Address 2 is > 60 characters"
End If
	
lcity:
//Validate City
If len(trim(This.getItemString(al_row,"city"))) > 50 Then
	This.Setfocus()
	This.SetColumn("City")
	iscurrvalcolumn = "city"
	Return "City is > 50 characters"
End If

lstate:
//Validate State
If len(trim(This.getItemString(al_row,"state"))) > 40 Then
	This.Setfocus()
	This.SetColumn("state")
	iscurrvalcolumn = "state"
	Return "State is > 40 characters"
End If

lzip:
//Validate Zip
If len(trim(This.getItemString(al_row,"zip"))) > 40 Then
	This.Setfocus()
	This.SetColumn("zip")
	iscurrvalcolumn = "zip"
	Return "Zip Code is > 40 characters"
End If

lcountry:
//Validate Country
If len(trim(This.getItemString(al_row,"country"))) > 30 Then
	This.Setfocus()
	This.SetColumn("country")
	iscurrvalcolumn = "country"
	Return "Country is > 30 characters"
End If

ltel:
//Validate Telephone
If len(trim(This.getItemString(al_row,"telephone"))) > 20 Then
	This.Setfocus()
	This.SetColumn("telephone")
	iscurrvalcolumn = "telephone"
	Return "Telephone is > 20 characters"
End If

lfax:
//Validate fax
If len(trim(This.getItemString(al_row,"fax"))) > 20 Then
	This.Setfocus()
	This.SetColumn("fax")
	iscurrvalcolumn = "fax"
	Return "Fax is > 20 characters"
End If

lcontact:
//Validate contact
If len(trim(This.getItemString(al_row,"contact"))) > 40 Then
	This.Setfocus()
	This.SetColumn("contact")
	iscurrvalcolumn = "contact"
	Return "Contact is > 40 characters"
End If

lprice:
//Validate Price Class
If len(trim(This.getItemString(al_row,"price_class"))) > 3 Then
	This.Setfocus()
	This.SetColumn("price_class")
	iscurrvalcolumn = "price_class"
	Return "Price Class is > 3 characters"
End If

ltype:
//Validate Customer Type
If len(trim(This.getItemString(al_row,"customer_type"))) > 20 Then
	This.Setfocus()
	This.SetColumn("customer_type")
	iscurrvalcolumn = "customer_type"
	Return "Customer Type is > 20 characters"
End If

lpriority:
//Validate Priority
If not isnumber(This.getItemString(al_row,"priority")) Then
	This.Setfocus()
	This.SetColumn("priority")
	iscurrvalcolumn = "priority"
	Return "Priority must be numeric"
ElseIf len(trim(This.getItemString(al_row,"priority"))) > 2 Then
	This.Setfocus()
	This.SetColumn("priority")
	iscurrvalcolumn = "priority"
	Return "priority is > 2 Digits"
End If

ldiscount:
//Validate discount
If not isnumber(This.getItemString(al_row,"discount")) Then
	This.Setfocus()
	This.SetColumn("discount")
	iscurrvalcolumn = "discount"
	Return "discount must be numeric"
ElseIf len(trim(This.getItemString(al_row,"discount"))) > 2 Then
	This.Setfocus()
	This.SetColumn("discount")
	iscurrvalcolumn = "discount"
	Return "discount is > 2 Digits"
End If



iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llUpdate,	&
		llPriority,	&
		lLDiscount, &
		llNew
		
String	lsCustCode,	&
			lsCustName,	&
			lsAddr1,		&
			lsaddr2,		&
			lsaddr3,		&
			lsaddr4,		&
			lsCity,		&
			lsState,		&
			lsZip,		&
			lsCountry,	&
			lsTel,		&
			lsFax,		&
			lsContact,	&
			lsClass,		&
			lsEmail_Address, lsRemark, lsUser_Field1, lsUser_Field2, lsUser_Field3, lsTax_Class, &
			lsExport_Control_Commodity_No, lsHarmonized_Code, lsVAT_ID, lsuser_field4, lsuser_field5,	&
			lsuser_field6, lsUser_Field7, lsUser_Field8, lsUser_Field9, lsUser_Field10, &
			lsType,		&
			lsErrText,	&
			lsSQL
			
Datetime		ldToday

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
//ldToday = Today()

llRowCount = This.RowCount()

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =0"
End If

//Update or Insert for each Row...

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsCustCode = left(trim(This.GetItemString(llRowPos,"customer_code")),20)
	lsCustname = left(trim(This.GetItemString(llRowPos,"customer_name")),60)
	lsaddr1 = left(trim(This.GetItemString(llRowPos,"Address1")),60)
	lsaddr2 = left(trim(This.GetItemString(llRowPos,"Address2")),60)
	lsaddr3 = left(trim(This.GetItemString(llRowPos,"Address3")),60)
	lsaddr4 = left(trim(This.GetItemString(llRowPos,"Address4")),60)
	lscity = left(trim(This.GetItemString(llRowPos,"city")),50)
	lsstate = left(trim(This.GetItemString(llRowPos,"state")),40)
	lszip = left(trim(This.GetItemString(llRowPos,"zip")),40)
	lscountry = left(trim(This.GetItemString(llRowPos,"country")),30)
	lstel = left(trim(This.GetItemString(llRowPos,"telephone")),20)
	lsfax = left(trim(This.GetItemString(llRowPos,"fax")),20)
	lscontact = left(trim(This.GetItemString(llRowPos,"contact")),40)
	lsclass = left(trim(This.GetItemString(llRowPos,"price_class")),3)
	lstype = left(trim(This.GetItemString(llRowPos,"customer_type")),20)
	lsEmail_Address = left(trim(This.GetItemString(llRowPos,"email_address")),250)
	lsRemark = left(trim(This.GetItemString(llRowPos,"remark")),250)
//	lsPriority = left(trim(This.GetItemString(llRowPos,"priority")),2)
	llPriority = Long(This.GetItemString(llRowPos,"priority"))
	lsUser_Field1 = left(trim(This.GetItemString(llRowPos,"user_field1")),10)
	lsUser_Field2 = left(trim(This.GetItemString(llRowPos,"user_field2")),20)
	lsUser_Field3 = left(trim(This.GetItemString(llRowPos,"user_field3")),30)
	lsTax_Class = left(trim(This.GetItemString(llRowPos,"tax_class")),3)
//	lsDiscount = left(trim(This.GetItemString(llRowPos,"discount")),2)
	llDiscount = Long(This.GetItemString(llRowPos,"discount"))
	lsExport_Control_Commodity_No = left(trim(This.GetItemString(llRowPos,"export_control_commodity_no")),15)
	lsHarmonized_Code = left(trim(This.GetItemString(llRowPos,"harmonized_code")),20)
	lsVAT_ID = left(trim(This.GetItemString(llRowPos,"vat_id")),20)
	lsuser_field4 = left(trim(This.GetItemString(llRowPos,"user_field4")),30)
	lsuser_field5 = left(trim(This.GetItemString(llRowPos,"user_field5")),30)
	lsuser_field6 = left(trim(This.GetItemString(llRowPos,"user_field6")),60)
	lsUser_Field7 = left(trim(This.GetItemString(llRowPos,"user_field7")),30)
	lsUser_Field8 = left(trim(This.GetItemString(llRowPos,"user_field8")),30)
	lsUser_Field9 = left(trim(This.GetItemString(llRowPos,"user_field9")),50)
	lsUser_Field10 = left(trim(This.GetItemString(llRowPos,"user_field10")),50)

	
	
//	//try update first
//	Update Customer Set
//	cust_name = :lsCustName,
//	address_1 = :lsaddr1,
//	address_2 = :lsaddr2,
//	City = :lsCity,
//	zip = :lsZip,
//	state = :lsState,
//	Country = :lsCountry,
//	tel = :lstel,
//	fax = :lsFax,
//	contact_person = :lsContact,
//	price_class = :lsClass,
//	customer_type = :lsType,
//	last_user = :gs_userid,
//	last_update = :ldToday
//	Where cust_code = :lsCustCode and project_id = :gs_project
//	Using Sqlca;

// 07/01 Pconkl - Build update statement dynamically, based on fields filled in on layout
// so we dont clear out previously entered data if missing from layout

	lsSQL = "Update Customer Set "
	If lsCustName > ' ' Then lsSQl += "cust_name = '" + lsCustName + "', "
	If lsaddr1 > ' ' Then lsSQl += "address_1 = '" + lsaddr1 + "', "
	If lsaddr2 > ' ' Then lsSQl += "address_2 = '" + lsaddr2 + "', "
	If lsaddr3 > ' ' Then lsSQl += "address_3 = '" + lsaddr3 + "', "
	If lsaddr4 > ' ' Then lsSQl += "address_4 = '" + lsaddr4 + "', "
	If lsCity > ' ' Then lsSQl += "City = '" + lsCity + "', "
	If lsState > ' ' Then lsSQl += "state = '" + lsstate + "', "
	If lsZip > ' ' Then lsSQl += "Zip = '" + lsZip + "', "
	If lsCountry > ' ' Then lsSQl += "country = '" + lsCountry + "', "
	If lsTel > ' ' Then lsSQl += "tel = '" + lstel + "', "
	If lsFax > ' ' Then lsSQl += "fax = '" + lsfax + "', "
	If lsContact > ' ' Then lsSQl += "contact_person = '" + lscontact + "', "
	If lsClass > ' ' Then lsSQl += "price_class = '" + lsclass + "', "
	If lsType > ' ' Then lsSQl += "customer_type = '" + lsType + "', "
	If lsEmail_Address > ' ' Then lsSQl += "Email_Address = '" + lsEmail_Address + "', "
	If lsRemark > ' ' Then lsSQl += "Remark = '" + lsRemark + "', "
//	If lsPriority > ' ' Then lsSQl += "Priority = " + lsPriority + ", "
	If llPriority > 0 Then lsSQL += "Priority = " + string(llpriority) + ", "
	If lsUser_Field1 > ' ' Then lsSQl += "User_Field1 = '" + lsUser_Field1 + "', "
	If lsUser_Field2 > ' ' Then lsSQl += "User_Field2 = '" + lsUser_Field2 + "', "
	If lsUser_Field3 > ' ' Then lsSQl += "User_Field3 = '" + lsUser_Field3 + "', "
	If lsTax_Class > ' ' Then lsSQl += "Tax_Class = '" + lsTax_Class + "', "
//	If lsDiscount > ' ' Then lsSQl += "Discount = " + lsDiscount + ", "
	If llDiscount > 0 Then lsSQL += "Discount = " + string(llDiscount) + ", "
	If lsExport_Control_Commodity_No > ' ' Then lsSQl += "Export_Control_Commodity_No = '" + lsExport_Control_Commodity_No + "', "
	If lsHarmonized_Code > ' ' Then lsSQl += "Harmonized_Code = '" + lsHarmonized_Code + "', "
	If lsVAT_ID > ' ' Then lsSQl += "VAT_ID = '" + lsVAT_ID + "', "
	If lsuser_field4 > ' ' Then lsSQl += "user_field4 = '" + lsuser_field4 + "', "
	If lsuser_field5 > ' ' Then lsSQl += "user_field5 = '" + lsuser_field5 + "', "
	If lsuser_field6 > ' ' Then lsSQl += "user_field6 = '" + lsuser_field6 + "', "
	If lsUser_Field7 > ' ' Then lsSQl += "User_Field7 = '" + lsUser_Field7 + "', "
	If lsUser_Field8 > ' ' Then lsSQl += "User_Field8 = '" + lsUser_Field8 + "', "
	If lsUser_Field9 > ' ' Then lsSQl += "User_Field9 = '" + lsUser_Field9 + "', "
	If lsUser_Field10 > ' ' Then lsSQl += "User_Field10 = '" + lsUser_Field10 + "', "
	lsSQl += "last_user = '" + gs_userid + "', last_update = '" + string(today(),'mm-dd-yy hh:mm:ss') + "'" /*last update*/
	lsSQl += " Where cust_code = '" + lsCustCode + "' and project_id = '" + gs_project + "'"

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
	
		Insert Into Customer (project_id,cust_code,cust_name,address_1,address_2,address_3, address_4, city,zip,state,country,tel,fax, email_address,remark,priority,user_field1, user_field2, user_field3,contact_person,price_class,tax_class,discount,export_control_commodity_no,harmonized_code,vat_id,user_field4,user_field5,user_field6,user_field7,user_field8,user_field9,user_field10,customer_type,last_user,last_update) values (:gs_project,:lsCustCode,:lsCustName,:lsAddr1,:lsaddr2,:lsaddr3,:lsaddr4,:lsCity,:lsZip,:lsState,:lsCountry,:lsTel,:lsFax, :lsEmail_Address,:lsRemark, :llPriority,:lsUser_Field1,:lsUser_Field2,:lsUser_Field3,:lsContact,:lsClass,:lsTax_Class,:llDiscount,:lsExport_Control_Commodity_No,:lsHarmonized_Code,:lsVat_id,:lsUser_Field4,:lsUser_Field5,:lsUser_Field6,:lsUser_Field7,:lsUser_Field8,:lsUser_Field9,:lsUser_Field10,:lsType,:gs_userid,:ldToday)
		Using SQLCA;
	
		If sqlca.sqlcode <> 0 Then
			This.SetRow(llRowPos)
			This.ScrollToRow(llRowPos)
			lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
			
			If Upper(gs_project) = 'CHINASIMS'  THEN
				SQLCA.DBParm = "disablebind =1"
			End If
			
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Unable to save changes to database!~r~r" + lsErrtext)
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

on u_dw_import_customer.create
call super::create
end on

on u_dw_import_customer.destroy
call super::destroy
end on

