HA$PBExportHeader$u_dw_import_item_serial_prefix.sru
$PBExportComments$+ Item Serial Prefix
forward
global type u_dw_import_item_serial_prefix from u_dw_import
end type
end forward

global type u_dw_import_item_serial_prefix from u_dw_import
integer width = 3931
integer height = 2064
string dataobject = "d_import_item_serial_prefix"
end type
global u_dw_import_item_serial_prefix u_dw_import_item_serial_prefix

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
public function string getcommastrippedvalue (string value, boolean adecimal)
end prototypes

public function string wf_validate (long al_row);//18-Dec-2013 :Madhu- Validate for valid field length and type

String	lsProject,lswh_code,lssupp_code,lssku,lsprefix,lsstartpos
boolean alphanum =false
		
long		llCount,llItemCount,llSuppCount

n_cst_string	lnv_string
// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "Project_Id"
		goto lsProject
	case "Supp_code"
		goto lssupp_code
	case "Sku"
		goto lssku
	case "Prefix"
		goto lsprefix
	Case "StartingPos"
		goto lsstartpos
		iscurrvalcolumn = ''
		return ''
End Choose

lsProject:
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

lsprefix:
//Alphanumeric
If this.getItemString(al_row,"Prefix") >' ' and (Not isnull(this.getItemString(al_row,"Prefix")))  Then
	lsprefix =this.getItemString(al_row,"Prefix")
	alphanum =lnv_string.of_isalphanum(lsprefix)

	If alphanum =TRUE Then
		If len(trim(lsprefix)) > 10 Then
			this.setfocus()
			this.setcolumn("Prefix")
			iscurrvalcolumn ="Prefix"
			return "'Prefix' is > 10 characters"
		End if
	else
		this.setfocus()
		this.setcolumn("Prefix")
		iscurrvalcolumn ="Prefix"
		return "'Prefix' should be Alphanumeric!"
	End If
Else
	this.setfocus()
	this.setcolumn("Prefix")
	iscurrvalcolumn ="Prefix"
	return "'Prefix cannot be null!"
End if

lsstartpos:
If this.getItemString(al_row,"StartingPos") >' ' and (Not isnull(this.getItemString(al_row,"StartingPos")))  Then
	If len(trim(this.getItemString(al_row,"StartingPos"))) > 2 Then
		this.setfocus()
		this.setcolumn("StartingPos")
		iscurrvalcolumn ="StartingPos"
		return "'StartingPos' is > 2 characters"
	End if
else
	this.setfocus()
	this.setcolumn("StartingPos")
	iscurrvalcolumn ="StartingPos"
	return "'StartingPos' cannot be null!"
End If

lssku =this.getItemString(al_row,"sku")
lssupp_code =this.getItemString(al_row,"supp_code")

If ((not isnull(lssupp_code)) and lssupp_code > '' and (not isnull(lssku)) and lssku >'' ) Then

	//sku+suppcode validation
	Select Count(*)  into :llCount
	from Item_Master
	Where  Project_Id= :gs_project and SKU =:lssku  and Supp_Code = :lssupp_code
	Using SQLCA;

	If llCount <= 0 Then
		This.Setfocus()
		Return "Record should be present in Item Master with combination of SKU = " +lssku +" Supplier= "  +lssupp_code
	End If

End If
iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();//18-Dec-2013 :Madhu - Added code to Insert/validate records on Item Master Putaway Storage Rule

String		lsProject,lssupp_code,lssku,lsprefix,lsstartpos
String 	lsSQL,lsErrorText,lsFind

long		llRowCount,llRowPos,llUpdate,llFindRow,ll_duplicaterow,llcount,llnew

llUpdate =0
llNew =0
ll_duplicaterow=0

llRowCount =this.Rowcount()

Execute Immediate " Begin Transaction " using SQLCA;

For llRowPos =1 to llRowCount

w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))

	lsProject = this.getItemString(llRowPos,"Project_Id")
	lssupp_code = this.getItemString(llRowPos,"supp_code")
	lssku = this.getItemString(llRowPos,"sku")
	lsprefix = this.getItemString(llRowPos,"Prefix")
	lsstartpos = this.getItemString(llRowPos,"StartingPos")

	lsFind = "sku = '" + lssku + "'"
	llFindRow =  this.Find(lsFind,0,this.RowCount())
	
	Do While llFindRow >0 
		llFindRow = this.Find(lsFind,llFindRow+1,this.RowCount()+1)
		
		IF llFindRow >1 Then
			ll_duplicaterow =llFindRow
		END IF
	Loop

//doesn't allow to update/insert duplicate records into Item Storage Rule table
If (ll_duplicaterow <> llRowPos) Then
	
		//check if record is already exists or not
		select count(*) into :llcount
		from Item_Serial_PRefix
		where Project_Id =:lsProject
		and sku=:lssku
		and supp_code =:lssupp_code
		using sqlca;
		
		If llcount >0 Then
			//prepare dynamic sql to update
			lsSQL ="Update Item_Serial_Prefix  Set   "
			If lsProject >' '  Then lsSQL += "Project_Id = '" +lsProject+"',"
			If lssku >' '  Then lsSQL += "SKU = '" +lssku+"',"
			If lssupp_code >' '  Then lsSQL += "Supp_Code = '" +lssupp_code+"',"
			If lsprefix >' '  Then lsSQL += "Prefix = '" +lsprefix+"',"
			If lsstartpos >' '  Then lsSQL += "Starting_Pos = '" +lsstartpos+"',"
			lsSQL += "Last_User ='"+ gs_userid+"',"
			lsSQL+= "Last_Update ='"+ string(Today()) +"'"
			
			
			lssql = getCommaStrippedValue(  lssql, false) //suppress commas, if exists at last
			
			
			lsSQL += "WHERE Project_Id = '"+ gs_project +"' and Sku = '"+lssku+"' and supp_code ='"+lssupp_code+"'"
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
			//insert records into Item Storage Rule table
			INSERT INTO Item_Serial_Prefix (Project_Id,SKU,Supp_Code,Prefix,Last_User,Last_Update,Starting_Pos)
			values (:lsProject,:lssku,:lssupp_code,:lsprefix,:gs_userid, SYSDATETIME(),:lsstartpos)
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
	MessageBox("Import","Doesn't allow to update/Insert Duplicate records into Item Serial Prefix for SKU= ~r~r~r" +lssku+ "  at row  " +string(ll_duplicaterow))
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

public function string getcommastrippedvalue (string value, boolean adecimal);
int ipos,lastpos,length

//get length of string

ipos = lastpos( value,"," ) 
length =len(value)

if  (length =ipos) Then
	value = left( value, ( ipos - 1) ) + right( value, len( value) - ipos )
End if
	
//do while ipos > 0
//	value = left( value, ( ipos - 1) ) + right( value, len( value) - ipos )
//	lastpos = ipos
//	ipos = pos( value,"," ) 
//loop

if not adecimal then return value

// make the last pos a period
if pos( value, "." ) = 0 then  // no decimal found
	if lastpos > 0 then	value = left( value, ( lastpos - 1 ) ) + "." + right( value, len( value) - ( lastpos -1 ) )
end if

return value

end function

on u_dw_import_item_serial_prefix.create
call super::create
end on

on u_dw_import_item_serial_prefix.destroy
call super::destroy
end on

