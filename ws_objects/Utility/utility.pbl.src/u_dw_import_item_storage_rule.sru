$PBExportHeader$u_dw_import_item_storage_rule.sru
$PBExportComments$+Item Master Putaway Storage Rule
forward
global type u_dw_import_item_storage_rule from u_dw_import
end type
end forward

global type u_dw_import_item_storage_rule from u_dw_import
integer width = 3918
integer height = 1680
string dataobject = "d_import_itemmaster_storage_rule"
end type
global u_dw_import_item_storage_rule u_dw_import_item_storage_rule

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
public function string getcommastrippedvalue (string value, boolean adecimal)
public function integer dwgetchild (readonly string n, ref datawindowchild c)
end prototypes

public function string wf_validate (long al_row);//16-Dec-2013 :Madhu- Validate for valid field length and type

String	lsProject,lswh_code,lssupp_code,lssku,lsdedicated_loc,lsqtyforloc ,  lsitemconsoltype, lsitemCtype,  &  
		 lsconsollotno, lslotno, lspono,  lsConsolPoNo, lsConsolPoNo2, lspono2, lsConsolExpdt, lsexpdt, lsConsolinvtype , lsinvtype
long		llCount,llItemcount,llSuppcount,llLocCount

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "Project_Id"
		goto lsProject
	Case "Wh_code"
		goto lswh_code
	case "Supp_code"
		goto lssupp_code
	case "Sku"
		goto lssku
	case "Dedicated_location"
		goto lsdedicated_loc
	Case "Qty_for_location"
		goto lsqtyforloc
	Case "Item_consol_type"  // SANTOSH- 25/05/02014 - ADDED consolidated columns
		goto lsitemconsoltype
	Case "Consol_Lot_No"
		goto lsconsollotno
	Case "Consol_po_no"
		goto lsConsolPoNo
	Case "Consol_po_no2"
		goto lsConsolPoNo2
	Case "Consol_exp_dt"
		goto lsConsolExpdt
	case "Consol_inv_type"
		goto lsConsolinvtype
		
		
		iscurrvalcolumn = ''
		return ''
End Choose

lsProject:
If this.getItemString(al_row,"project_id") >' ' and (Not isnull(this.getItemString(al_row,"project_id")))  then
	If len(trim(this.getItemString(al_row,"project_id") )) > 10 Then
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


lswh_code:
If this.getItemString(al_row,"wh_code") >' ' and (Not isnull(this.getItemString(al_row,"wh_code")))  Then
	If len(trim(this.getItemString(al_row,"wh_code"))) > 10 Then
		this.setfocus()
		this.setcolumn("wh_code")
		iscurrvalcolumn ="wh_code"
		return "'wh code' is > 10 characters"
	End if
else
	this.setfocus()
	this.setcolumn("wh_code")
	iscurrvalcolumn ="wh_code"
	return "'wh code' cannot be null!"
End If


lssupp_code:
If this.getItemString(al_row,"supp_code") >' ' and (Not isnull(this.getItemString(al_row,"supp_code"))) Then

	lssupp_code =this.getItemString(al_row,"supp_code")	

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
If this.getItemString(al_row,"sku") >' ' and (Not isnull(this.getItemString(al_row,"sku"))) Then
	
	lssku =this.getItemString(al_row,"sku")
	
	//sku validation
	Select Count(*)  into :llItemCount
	from Item_Master
	Where  Project_Id= :gs_project and SKU =:lssku
	Using SQLCA;

	If llItemCount <= 0 Then
		This.Setfocus()
		this.setcolumn("sku")
		Return "Invalid sku - " + lssku
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

lsdedicated_loc:
If this.getItemString(al_row,"Dedicated_location") >' ' and (Not isnull(this.getItemString(al_row,"Dedicated_location"))) Then
	lsdedicated_loc =this.getItemString(al_row,"Dedicated_location")
	lswh_code =this.getItemString(al_row,"wh_code")
	
	Select Count(*)  into :llLocCount
	from Location
	Where  L_code= :lsdedicated_loc and wh_Code = :lswh_code
	Using SQLCA;

	If llLocCount <= 0 Then
		This.Setfocus()
		this.setcolumn("Dedicated_location")
		Return "Invalid Dedicated Location - " +lsdedicated_loc + " for this wh code"
	End If
	
	If len(trim(this.getItemString(al_row,"Dedicated_location"))) > 10 Then
		this.setfocus()
		this.setcolumn("Dedicated_location")
		iscurrvalcolumn ="Dedicated_location"
		return "'Dedicated location' is > 10 characters"
	End if
else
		this.setfocus()
		this.setcolumn("Dedicated_location")
		iscurrvalcolumn ="Dedicated_location"
		
		// SANTOSH -28/05/2014 as dedicated locations may be null as per sugggestion  by the customer.
		if ( this.getItemString(al_row,"Dedicated_location") = '-' ) Then
			return "'Dedicated location'  cannot be (-) hyphen"
		end if 
		//return "'Dedicated location' cannot be null!"
End If


lsqtyforloc:
If this.getItemString(al_row,"Qty_for_location") >' ' and (Not isnull(this.getItemString(al_row,"Qty_for_location"))) Then
	lssupp_code = this.getItemString(al_row,"supp_code")
	lssku = this.getItemString(al_row,"sku")
		
	If len(trim(this.getItemString(al_row,"Qty_for_location"))) > 10 Then
		this.setfocus()
		this.setcolumn("Qty_for_location")
		iscurrvalcolumn ="Qty_for_location"
		return "'Qty for location' is > 10 characters"
	End if
else
	this.setfocus()
	this.setcolumn("Qty_for_location")
	iscurrvalcolumn ="Qty_for_location"
	return "'Qty for location' cannot be null!"
End If

//check whether record exists in Item Master or not
If ((not isnull(lssupp_code)) and lssupp_code > '' and (not isnull(lssku)) and lssku >'' ) Then
	//sku+supp code validation
	Select Count(*)  into :llCount
	from Item_Master
	Where  Project_Id= :gs_project and SKU =:lssku  and Supp_Code = :lssupp_code
	Using SQLCA;

	If llCount <= 0 Then
		This.Setfocus()
		Return "Record should be present in Item Master with combination of SKU = " +lssku +" Supplier= "  +lssupp_code
	End If

End If

//SANTOSH-29/05/2014- start  added  6 extra columns 
lsitemconsoltype: 
If this.getItemString(al_row,"Item_consol_type") >' ' and (Not isnull(this.getItemString(al_row,"Item_consol_type"))) Then
	lsitemCtype = upper( trim(this.getItemString(al_row,"Item_consol_type")))
	lssku = this.getItemString(al_row,"sku")
		
	If len(trim(this.getItemString(al_row,"Item_consol_type"))) > 1 Then
		this.setfocus()
		this.setcolumn("Item_consol_type")
		iscurrvalcolumn ="Item_consol_type"
		return "'Item_consol_type for ' is > 1 characters"
	End if
	if  (lsitemCtype  <>"S"  and   lsitemCtype  <> "G"  and  lsitemCtype <> "N") Then
		this.setfocus()
		this.setcolumn("Item_consol_type")
		iscurrvalcolumn ="Item_consol_type"
		return "'Item_consol_type  '  should be S,G or N "
	End If
	
else
	this.setfocus()
	this.setcolumn("Item_consol_type")
	iscurrvalcolumn ="Item_consol_type"
	return "'Item_consol_type' cannot be null!"
End If


lsconsollotno:
If this.getItemString(al_row,"Consol_lot_no") >' ' and (Not isnull(this.getItemString(al_row,"Consol_lot_no"))) Then
	lslotno = upper(trim(this.getItemString(al_row,"Consol_lot_no")))
	lssku = this.getItemString(al_row,"sku")
		
	If len(trim(this.getItemString(al_row,"Consol_lot_no"))) > 1 Then
		this.setfocus()
		this.setcolumn("Consol_lot_no")
		iscurrvalcolumn ="Consol_lot_no"
		return "'Consol_lot_no for ' is > 1 characters"
	End if
	if  (lslotno <>'Y' and lslotno <>'N') Then
		this.setfocus()
		this.setcolumn("Consol_lot_no")
		iscurrvalcolumn ="Consol_lot_no"
		return "'Consol_lot_no  '  should be Y or N or Blank"
	End If
		
else
	this.setfocus()
	this.setcolumn("Consol_lot_no")
	iscurrvalcolumn ="Consol_lot_no"
	//return "'Item_consol_type' cannot be null!"
End If

lsConsolPoNo:
If this.getItemString(al_row,"Consol_po_no") >' ' and (Not isnull(this.getItemString(al_row,"Consol_po_no"))) Then
	lspono = upper(trim(this.getItemString(al_row,"Consol_po_no")))
	lssku = this.getItemString(al_row,"sku")
		
	If len(trim(this.getItemString(al_row,"Consol_po_no"))) > 1 Then
		this.setfocus()
		this.setcolumn("Consol_po_no")
		iscurrvalcolumn ="Consol_po_no"
		return "'Consol_po_no for ' is > 1 characters"
	End if
	if  ( lspono <> 'Y' and lspono <>'N')  Then
		this.setfocus()
		this.setcolumn("Consol_po_no")
		iscurrvalcolumn ="Consol_po_no"
		return "'Consol_po_no  '  should be Y or N or Blank"
	End If
		
else
	this.setfocus()
	this.setcolumn("Consol_po_no")
	iscurrvalcolumn ="Consol_po_no"
	//return "'Item_consol_type' cannot be null!"
End If

lsConsolPoNo2:
If this.getItemString(al_row,"Consol_po_no2") >' ' and (Not isnull(this.getItemString(al_row,"Consol_po_no2"))) Then
	lspono2 = upper(trim(this.getItemString(al_row,"Consol_po_no2")))
	lssku = this.getItemString(al_row,"sku")
		
	If len(trim(this.getItemString(al_row,"Consol_po_no2"))) > 1 Then
		this.setfocus()
		this.setcolumn("Consol_po_no2")
		iscurrvalcolumn ="Consol_po_no2"
		return "'Consol_po_no2 for ' is > 1 characters"
	End if
	if  (lspono2 <> 'Y' and lspono2 <>'N') Then
		this.setfocus()
		this.setcolumn("Consol_po_no2")
		iscurrvalcolumn ="Consol_po_no2"
		return "'Consol_po_no2  '  should be Y or N or Blank"
	End If
		
else
	this.setfocus()
	this.setcolumn("Consol_po_no2")
	iscurrvalcolumn ="Consol_po_no2"
	//return "'Item_consol_type' cannot be null!"
End If


lsConsolinvtype:
If this.getItemString(al_row,"Consol_inv_type") >' ' and (Not isnull(this.getItemString(al_row,"Consol_inv_type"))) Then
	lsinvtype = upper(trim(this.getItemString(al_row,"Consol_inv_type")))
	lssku = this.getItemString(al_row,"sku")
		
	If len(trim(this.getItemString(al_row,"Consol_inv_type"))) > 1 Then
		this.setfocus()
		this.setcolumn("Consol_inv_type")
		iscurrvalcolumn ="Consol_inv_type"
		return "'Consol_inv_type for ' is > 1 characters"
	End if
	if  (lsinvtype <>'Y' and lsinvtype <>'N' ) Then
		this.setfocus()
		this.setcolumn("Consol_inv_type")
		iscurrvalcolumn ="Consol_inv_type"
		return "'Consol_inv_type  '  should be Y or N or Blank"
	End If
		
else
	this.setfocus()
	this.setcolumn("Consol_inv_type")
	iscurrvalcolumn ="Consol_inv_type"
	return "'consol Inv Type' cannot be null!"
End If


lsConsolExpdt:
If this.getItemString(al_row,"Consol_exp_dt") >' ' and (Not isnull(this.getItemString(al_row,"Consol_exp_dt"))) Then
	lsexpdt = upper(trim(this.getItemString(al_row,"Consol_exp_dt")))
	lssku = this.getItemString(al_row,"sku")
		
	If len(trim(this.getItemString(al_row,"Consol_exp_dt"))) > 1 Then
		this.setfocus()
		this.setcolumn("Consol_exp_dt")
		iscurrvalcolumn ="Consol_exp_dt"
		return "'Consol_exp_dt for ' is > 1 characters"
	End if
	if  ( lsexpdt <>'Y' and lsexpdt <>'N') Then
		this.setfocus()
		this.setcolumn("Consol_exp_dt")
		iscurrvalcolumn ="Consol_exp_dt"
		return "'Consol_exp_dt  '  should be Y or N or Blank"
	End If
		
else
	this.setfocus()
	this.setcolumn("Consol_exp_dt")
	iscurrvalcolumn ="Consol_exp_dt"
	//return "'Item_consol_type' cannot be null!"
End If
//SANTOSH-29/05/2014- End   added  6 extra columns 


iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();//16-Dec-2013 :Madhu - Added code to Insert/validate records on Item Master Putaway Storage Rule

String		lsProject,lswh_code,lssupp_code,lssku,lsdedicated_loc,lsqtyforloc,lsequipment_type,lsstorage_type,lsstorage_rule
String 	lsSQL,lsErrorText,lsFind, lsItemcon_type, lsConlotno, lsConpono, lsConpono2, lsConexpdt, lsConinv_type

long		llRowCount,llRowPos,llUpdate,llFindRow,ll_duplicaterow,llcount,llnew

llUpdate =0
llNew =0
ll_duplicaterow=0

llRowCount =this.Rowcount()

Execute Immediate " Begin Transaction " using SQLCA;

For llRowPos =1 to llRowCount

w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))

	lsProject = this.getItemString(llRowPos,"Project_Id")
	lswh_code = this.getItemString(llRowPos,"wh_code")
	lssupp_code = this.getItemString(llRowPos,"supp_code")
	lssku = this.getItemString(llRowPos,"sku")
	lsdedicated_loc = this.getItemString(llRowPos,"Dedicated_location")
	lsqtyforloc = this.getItemString(llRowPos,"Qty_for_location")
	lsequipment_type = this.getItemString(llRowPos,"Equipment_Type")
	lsstorage_type = this.getItemString(llRowPos,"Storage_Type")
	lsstorage_rule = this.getItemString(llRowPos,"Storage_Rule")
	lsItemcon_type =this.getItemString(llRowPos,"Item_consol_type") ////SANTOSH- 30/05/2014 - added 6 indication columns.
	lsConlotno  =this.getItemString(llRowPos,"Consol_lot_no")
	 lsConpono=this.getItemString(llRowPos,"Consol_po_no")
	 lsConpono2 =this.getItemString(llRowPos,"Consol_po_no2")
	 lsConexpdt =this.getItemString(llRowPos,"Consol_exp_dt")
	 lsConinv_type =this.getItemString(llRowPos,"Consol_inv_type")																				


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
		from Item_Storage_Rule
		where Project_Id =:lsProject
		and sku=:lssku
		and supp_code =:lssupp_code
		and wh_code =:lswh_code
		using sqlca;
		
		If llcount >0 Then
			//prepare dynamic sql to update
			lsSQL ="Update Item_Storage_Rule Set   "
			If lsProject >' '  Then lsSQL += "Project_Id = '" +lsProject+"',"
			If lswh_code >' '  Then lsSQL += "Wh_Code = '" +lswh_code+"',"
			If lssupp_code >' '  Then lsSQL += "Supp_Code = '" +lssupp_code+"',"
			If lssku >' '  Then lsSQL += "SKU = '" +lssku+"',"
			If lsdedicated_loc >' '  Then lsSQL += "Dedicated_Location = '" +lsdedicated_loc+"',"
			If lsqtyforloc >' '  Then lsSQL += "Qty_For_Location = '" +lsqtyforloc+"',"
			If lsequipment_type >' '  Then lsSQL += "Equipment_Type_Cd = '" +lsequipment_type+"',"
			If lsstorage_type >' '  Then lsSQL += "Storage_Type_Cd = '" +lsstorage_type+"',"
			If lsstorage_rule >' '  Then lsSQL += "Storage_Rule_Cd = '" +lsstorage_rule +"',"
			
			If lsItemcon_type >' '  Then lsSQL += "Item_consol_type = '" +lsItemcon_type +"',"  // santosh - 30/05/2014- adding for extra 6 columns
			If lsConlotno >' '  Then lsSQL += "consol_lot_no = '" +lsConlotno +"',"
			If lsConpono >' '  Then lsSQL += "consol_po_no = '" +lsConpono +"',"
			If lsConpono2 >' '  Then lsSQL += "consol_po_no2 = '" +lsConpono2 +"',"
			If lsConexpdt >' '  Then lsSQL += "consol_exp_dt = '" +lsConexpdt +"',"
			If lsConinv_type >' '  Then lsSQL += "consol_inv_type = '" +lsConinv_type +"',"
				
			lsSQL += "Last_User ='"+ gs_userid+"',"
			lsSQL+= "Last_Update ='"+ string(Today()) +"'"
			
			
			lssql = getCommaStrippedValue(  lssql, false) //suppress commas, if exists at last
			
			
			lsSQL += "WHERE Project_Id = '"+ gs_project +"' and Sku = '"+lssku+"' and supp_code ='"+lssupp_code+"' and wh_code ='"+lswh_code+"'"
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
			INSERT INTO Item_Storage_Rule (Project_Id,SKU,Supp_Code,WH_Code,Storage_Rule_Cd,Equipment_Type_Cd,Storage_Type_Cd,Dedicated_Location,Qty_For_Location, Item_consol_type,consol_lot_no, consol_po_no, consol_po_no2, consol_exp_dt, consol_inv_type, Last_User,Last_Update)
			values (:lsProject,:lssku,:lssupp_code,:lswh_code,:lsstorage_rule,:lsequipment_type,:lsstorage_type,:lsdedicated_loc,:lsqtyforloc,:lsItemcon_type,:lsConlotno,:lsConpono, :lsConpono2,:lsConexpdt, :lsConinv_type,  :gs_userid, SYSDATETIME())
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
	MessageBox("Import","Doesn't allow to update/Insert Duplicate records into Putaway Storage Rule for SKU= ~r~r~r" +lssku+ "  at row  " +string(ll_duplicaterow))
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

public function string getcommastrippedvalue (string value, boolean adecimal);// string = getCommaStrippedValue( string value )

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

public function integer dwgetchild (readonly string n, ref datawindowchild c);DataWindowChild ldwc_equipmnt

this.getChild('equipment_type',ldwc_equipmnt)
ldwc_equipmnt.SetTransObject(SQLCA)
ldwc_equipmnt.Retrieve(gs_Project)
return 1
end function

on u_dw_import_item_storage_rule.create
call super::create
end on

on u_dw_import_item_storage_rule.destroy
call super::destroy
end on

event constructor;call super::constructor;Datawindowchild ldwc_equipment_type,ldwc_storage_type,ldwc_storage_rule

this.GetChild('equipment_type',ldwc_equipment_type)
ldwc_equipment_type.SetTransObject(SQLCA)
ldwc_equipment_type.Retrieve(gs_Project)

this.GetChild('storage_type',ldwc_storage_type)
ldwc_storage_type.SetTransObject(SQLCA)
ldwc_storage_type.Retrieve(gs_Project)

this.GetChild('storage_rule',ldwc_storage_rule)
ldwc_storage_rule.SetTransObject(SQLCA)
ldwc_storage_rule.Retrieve(gs_Project)
end event

