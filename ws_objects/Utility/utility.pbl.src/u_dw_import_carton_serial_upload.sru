$PBExportHeader$u_dw_import_carton_serial_upload.sru
$PBExportComments$+ Import Carton Serial records.
forward
global type u_dw_import_carton_serial_upload from u_dw_import
end type
end forward

global type u_dw_import_carton_serial_upload from u_dw_import
string dataobject = "d_import_carton_serial_upload"
end type
global u_dw_import_carton_serial_upload u_dw_import_carton_serial_upload

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);//10-Apr-2014 :Madhu- Validate for valid field length and type

String	lsProject_Id,lsCarton_Id,lsSerial_No,lsMAC_Id,lsPallet_Id,lssku,lssupp_code
long		llCount,llItemCount,llSuppCount

n_cst_string	lnv_string
// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "Project_Id"
		goto lsProject_Id
	Case "Carton_Id"
		goto lsCarton_Id
	Case "Serial_No"
		goto lsSerial_No
	Case "MAC_Id"
		goto lsMAC_Id
	Case "Pallet_Id"
		goto lsPallet_Id
	Case "Sku"
		goto lssku
	Case "Supp_code"
		goto lssupp_code
		iscurrvalcolumn = ''
		return ''
End Choose

lsProject_Id:
If this.getItemString(al_row,"project_id") >' ' and (Not isnull(this.getItemString(al_row,"project_id")))  then
	If len(trim(this.getItemString(al_row,"project_id"))) > 10 Then
		this.setfocus()
		this.setcolumn("Project_Id")
		iscurrvalcolumn ="Project_Id"
		return "'Project Id' is > 10 characters"
	End if
else
	this.setfocus()
	this.setcolumn("project_id")
	iscurrvalcolumn ="project_id"
	return "'Project Id' cannot be null!"
End If

lsCarton_Id:
If this.getItemString(al_row,"Carton_Id") >' ' and (Not isnull(this.getItemString(al_row,"Carton_Id"))) then
	if len(trim(this.getITemString(al_row,"Carton_Id"))) > 20 then
		this.setfocus()
		this.setcolumn("Carton_Id")
		iscurrvalcolumn ="Carton_Id"
		return "Carton Id' is > 20 characters"
	End if
else
	this.setfocus()
	this.setcolumn("Carton_Id")
	iscurrvalcolumn ="Carton_Id"
	return "Carton_Id' cannot be null!"
End If

lsSerial_No:
If this.getItemString(al_row,"Serial_No") >' ' and (Not isnull(this.getItemString(al_row,"Serial_No"))) then
	if len(trim(this.getITemString(al_row,"Serial_No"))) > 50 then
		this.setfocus()
		this.setcolumn("Serial_No")
		iscurrvalcolumn ="Serial_No"
		return "Serial_No' is > 50 characters"
	End if
else
	this.setfocus()
	this.setcolumn("Serial_No")
	iscurrvalcolumn ="Serial_No"
	return "Serial_No' cannot be null!"
End If

lsMAC_Id:
If this.getItemString(al_row,"MAC_Id") >' ' and (Not isnull(this.getItemString(al_row,"MAC_Id"))) then
	if len(trim(this.getITemString(al_row,"MAC_Id"))) > 50 then
		this.setfocus()
		this.setcolumn("MAC_Id")
		iscurrvalcolumn ="MAC_Id"
		return "MAC_Id' is > 50 characters"
	End if
else
	this.setfocus()
	this.setcolumn("MAC_Id")
	iscurrvalcolumn ="MAC_Id"
	return "MAC_Id' cannot be null!"
End If

lsPallet_Id:
If this.getItemString(al_row,"Pallet_Id") >' ' and (Not isnull(this.getItemString(al_row,"Pallet_Id"))) then
	if len(trim(this.getITemString(al_row,"Pallet_Id"))) > 20 then
		this.setfocus()
		this.setcolumn("Pallet_Id")
		iscurrvalcolumn ="Pallet_Id"
		return "Pallet_Id' is > 20 characters"
	End if
else
	this.setfocus()
	this.setcolumn("Pallet_Id")
	iscurrvalcolumn ="Pallet_Id"
	return "Pallet_Id' cannot be null!"
End If

lssupp_code:
If this.getItemString(al_row,"supp_code") >' ' and (Not isnull(this.getItemString(al_row,"supp_code")))  Then
	
	lssupp_code = this.getItemString(al_row,"supp_code")

	Select Count(*)  into :llSuppCount
	from Supplier
	Where  Project_Id= :gs_project  and Supp_Code = :lssupp_code
	Using SQLCA;

	If llSuppCount <= 0 Then
		This.Setfocus()
		this.setcolumn("supp_code")
		Return " Invalid supplier - " +lssupp_code
	End If
	
	If len(trim(this.getItemString(al_row,"supp_code"))) > 20 Then
		this.setfocus()
		this.setcolumn("supp_code")
		iscurrvalcolumn ="supp_code"
		return "'supp code' is > 20 characters"
	End if
else
	this.setfocus()
	this.setcolumn("supp_code")
	iscurrvalcolumn ="supp_code"
	return "'supp code' cannot be null!"
End If

lssku:
If this.getItemString(al_row,"sku") >' ' and (Not isnull(this.getItemString(al_row,"sku")))  Then
	lssku = this.getItemString(al_row,"sku")
	
	Select Count(*)  into :llItemCount
	from Item_Master
	Where  Project_Id= :gs_project and SKU =:lssku
	Using SQLCA;

	If llItemCount <= 0 Then
		This.Setfocus()
		this.setcolumn("sku")
		Return "Invalid  SKU - " +lssku
	End If
	
	If len(trim(this.getItemString(al_row,"sku"))) > 50 Then
		this.setfocus()
		this.setcolumn("sku")
		iscurrvalcolumn ="sku"
		return "'sku' is > 50 characters"
	End if
else
	this.setfocus()
	this.setcolumn("sku")
	iscurrvalcolumn ="sku"
	return "'sku' cannot be null!"
End If


iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();//10-Apr-2014 :Madhu - Added code to Insert/validate records into Carton_Serial table

String		lsProject,lsCarton_Id,lsSerial_No,lsMAC_Id,lsPallet_Id,lssku,lssupp_code,lsCountry_Of_Origin
String		lsDO_No,lsRO_No,lsStatus_Cd,lsUser_Field1,lsUser_Field2,lsUser_Field3,lsUser_Field4,lsUser_Field5
String		lsUser_Field6,lsUser_Field7,lsUser_Field8,lsUser_Field9,lsUser_Field10,lsSource
String 	lsSQL,lsErrorText,lsFind
DateTime ldManufacture_Date,ldlast_update

long		llRowCount,llRowPos,llUpdate,llFindRow,ll_duplicaterow,llcount,llnew
long		llPallet_Qty,llCarton_Qty

llUpdate =0
llNew =0
ll_duplicaterow=0

llRowCount =this.Rowcount()

Execute Immediate " Begin Transaction " using SQLCA;

For llRowPos =1 to llRowCount

w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))

	lsProject= this.getItemString(llRowPos,"Project_Id")
	lsCarton_Id=this.getItemString(llRowPos,"Carton_Id")
	lsSerial_No = this.getItemString(llRowPos,"Serial_No")
	lsMAC_Id = this.getItemString(llRowPos,"MAC_Id")
	lsPallet_Id = this.getItemString(llRowPos,"Pallet_Id")
	lssku = this.getItemString(llRowPos,"sku")	
	lssupp_code = this.getItemString(llRowPos,"supp_code")
	lsCountry_Of_Origin= this.getItemString(llRowPos,"Country_Of_Origin")
	ldManufacture_Date = this.getItemDateTime(llRowPos,"Manufacture_Date")
	lsDO_No = this.getItemString(llRowPos,"DO_No")
	lsRO_No = this.getItemString(llRowPos,"RO_No")
	ldlast_update = this.getITemDateTime(llRowPos,"LastUpdate")
	lsStatus_Cd = this.getItemString(llRowPos,"Status_Cd")
	llPallet_Qty= this.getItemNumber(llRowPos,"Pallet_Qty")
	llCarton_Qty = this.getItemNumber(llRowPos,"Carton_Qty")
	lsUser_Field1 = this.getItemString(llRowPos,"User_Field1")
	lsUser_Field2 = this.getItemString(llRowPos,"User_Field2")
	lsUser_Field3 = this.getItemString(llRowPos,"User_Field3")
	lsUser_Field4 = this.getItemString(llRowPos,"User_Field4")
	lsUser_Field5 = this.getItemString(llRowPos,"User_Field5")
	lsUser_Field6 = this.getItemString(llRowPos,"User_Field6")
	lsUser_Field7 = this.getItemString(llRowPos,"User_Field7")
	lsUser_Field8 = this.getItemString(llRowPos,"User_Field8")
	lsUser_Field9 = this.getItemString(llRowPos,"User_Field9")
	lsUser_Field10 = this.getItemString(llRowPos,"User_Field10")
	lsSource = this.getItemString(llRowPos,"Source")
	
	lsFind = "sku = '" + lssku + "' and Carton_Id ='" + lsCarton_Id +"' and Pallet_Id = '" + lsPallet_Id + "' and Serial_No ='" + lsSerial_No + "'"
	llFindRow =  this.Find(lsFind,0,this.RowCount())
	
	Do While llFindRow >0 
		llFindRow = this.Find(lsFind,llFindRow+1,this.RowCount()+1)
		
		IF llFindRow >1 Then
			ll_duplicaterow =llFindRow
		END IF
	Loop

//Source is blank, store with UserId
IF lsSource ='' OR isnull(lsSource) Then
	lsSource =gs_userId;
END IF

//doesn't allow to update/insert duplicate records into Item Storage Rule table
If (ll_duplicaterow <> llRowPos) Then
	
		//check if record is already exists or not
		select count(*) into :llcount
		from Carton_Serial with (nolock)
		where Project_Id =:lsProject
		and sku=:lssku
		and supp_code =:lssupp_code
		and Carton_Id =:lsCarton_Id
		and Pallet_Id =:lsPallet_Id
		and Mac_Id =:lsMac_Id
		and Serial_No =:lsSerial_No
		using sqlca;
		
		If llcount >0 Then
			//prepare dynamic sql to update
			lsSQL ="Update Carton_Serial  Set   "
			If lsProject >' '  Then lsSQL += "Project_Id = '" +lsProject+"',"
			If lsCarton_Id > ' ' Then lsSQL += "Carton_Id ='" + lsCarton_Id + "',"
			If lsSerial_No > ' ' Then lsSQL += "Serial_No ='" + lsSerial_No + "',"
			If lsMAC_Id > ' ' Then lsSQL += "MAC_Id ='" + lsMAC_Id + "',"
			If lsPallet_Id > ' ' Then lsSQL += "Pallet_Id ='" + lsPallet_Id + "',"
			If lssku >' '  Then lsSQL += "SKU = '" +lssku+"',"
			If lssupp_code >' '  Then lsSQL += "Supp_Code = '" +lssupp_code+"',"
			If lsCountry_Of_Origin > ' ' Then lsSQL += "Country_Of_Origin ='" + lsCountry_Of_Origin + "',"
			If string(ldManufacture_Date) > ' '  Then lsSQL += "Manufacture_Date ='" + String(ldManufacture_Date,'YYYY-MM-DD') +"',"
			If lsDO_No > ' ' Then lsSQL += "DO_No ='" + lsDO_No + "',"
			If lsRO_No > ' ' Then lsSQL += "RO_No ='" + lsRO_No + "',"
			If string(ldlast_update) > ' '  Then lsSQL += "LastUpdate ='" + String(ldlast_update,'YYYY-MM-DD') +"',"
			If lsStatus_Cd > ' ' Then lsSQL += "Status_Cd ='" + lsStatus_Cd + "',"
			If llPallet_Qty > 0 Then lsSQL += "Pallet_Qty ='" + String(llPallet_Qty) + "',"
			If llCarton_Qty > 0 Then lsSQL += "Carton_Qty ='" + String(llCarton_Qty) + "',"
			If lsUser_Field1 > ' ' Then lsSQL += "User_Field1 ='" + lsUser_Field1 + "',"
			If lsUser_Field2 > ' ' Then lsSQL += "User_Field2 ='" + lsUser_Field2 + "',"
			If lsUser_Field3 > ' ' Then lsSQL += "User_Field3 ='" + lsUser_Field3 + "',"
			If lsUser_Field4 > ' ' Then lsSQL += "User_Field4 ='" + lsUser_Field4 + "',"
			If lsUser_Field5 > ' ' Then lsSQL += "User_Field5 ='" + lsUser_Field5 + "',"																					
			If lsUser_Field6 > ' ' Then lsSQL += "User_Field6 ='" + lsUser_Field6 + "',"
			If lsUser_Field7 > ' ' Then lsSQL += "User_Field7 ='" + lsUser_Field7 + "',"
			If lsUser_Field8 > ' ' Then lsSQL += "User_Field8 ='" + lsUser_Field8 + "',"
			If lsUser_Field9 > ' ' Then lsSQL += "User_Field9 ='" + lsUser_Field9 + "',"
			If lsUser_Field10 > ' ' Then lsSQL += "User_Field10 ='" + lsUser_Field10+ "',"
			If lsSource > ' ' Then lsSQL += "Source ='" + lsSource + "'"

		lsSQL += "WHERE Project_Id = '"+ gs_project +"' and Sku = '"+lssku+ "' and supp_code ='" +lssupp_code+"' and Carton_Id = '"+ lsCarton_Id + &
		 +"' and Pallet_Id ='"+ lsPallet_Id +"' and Mac_Id ='"+lsMac_Id +"' and Serial_No = '"+ lsSerial_No + "'"
		Execute Immediate :lsSQL using SQLCA;
		
		
			If sqlca.sqlcode <> 0 Then
				lsErrorText =sqlca.sqlerrtext
				Execute Immediate "ROLL BACK" using SQLCA;
			
				MessageBox("Import","Unable to save changes to database!~r~r" +lsErrorText)
				SetPointer(Arrow!)
				Return -1	
			ELSE
				llUpdate++
			END IF
	ELSE
			//insert records into Carton _Serial table
			INSERT INTO Carton_Serial (Project_Id,Carton_Id,Serial_No,MAC_Id,Pallet_Id,SKU,Supp_Code,
				Country_Of_Origin,Manufacture_Date,DO_No,RO_No,Last_Update,Status_Cd,Pallet_Qty,Carton_Qty,
				User_Field1,User_Field2,User_Field3,User_Field4,User_Field5,User_Field6,User_Field7,User_Field8,
				User_Field9,User_Field10,Source,Record_Create_Date)
				
			values (:lsProject,:lsCarton_Id,:lsSerial_No, :lsMAC_Id,:lsPallet_Id,:lssku,:lssupp_code, 
				:lsCountry_Of_Origin,:ldManufacture_Date,:lsDO_No,:lsRO_No,:ldlast_update,:lsStatus_Cd,:llPallet_Qty,:llCarton_Qty,
				:lsUser_Field1,:lsUser_Field2,:lsUser_Field3,:lsUser_Field4,:lsUser_Field5,:lsUser_Field6,:lsUser_Field7,:lsUser_Field8,
				:lsUser_Field9,:lsUser_Field10,:lsSource,SYSDATETIME())
			using sqlca;
	
		If sqlca.sqlcode <> 0 Then
			this.SetRow(llRowPos)
			this.ScrollToRow(llRowPos)
			lsErrorText = sqlca.sqlerrtext /*error text lost in rollback*/

			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Unable to save changes to database!~r~r" + lsErrortext)
			SetPointer(Arrow!)
			Return -1
		Else
			llnew ++
		End If
END IF

ELSE
	MessageBox("Import","Doesn't allow to update/Insert Duplicate records into Carton Serial for SKU= ~r~r~r" +lssku+ "  at row  " +string(ll_duplicaterow))
END IF	

Next

Execute Immediate "COMMIT" using SQLCA;

If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database")
	Return -1
End if 

MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "~r~rRecords Added: " + String(llNew))

w_main.SetmicroHelp("READY")
Setpointer(Arrow!)
return 0
end function

on u_dw_import_carton_serial_upload.create
call super::create
end on

on u_dw_import_carton_serial_upload.destroy
call super::destroy
end on

