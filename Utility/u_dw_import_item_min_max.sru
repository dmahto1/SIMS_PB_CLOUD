HA$PBExportHeader$u_dw_import_item_min_max.sru
$PBExportComments$Import AC DElco Sku information
forward
global type u_dw_import_item_min_max from u_dw_import
end type
end forward

global type u_dw_import_item_min_max from u_dw_import
integer width = 3076
integer height = 1571
string title = "Import ItemMaster MIN/Max"
string dataobject = "d_import_itemaster_min_max"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_item_min_max u_dw_import_item_min_max

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);//Jxlim 03/01/2011 Import ItemMaster Min/Max
String	lsProject, lsWh_code, lsSupplier, lsSku, lsOwner
long		llCount, llmin_rop, llmax_supply, llreorder

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "project_id"
		goto lproj
	case "wh_code"
		goto lwh
	Case "sku"
		goto lsku
	case "supp_code"
		goto lsupplier
	case "owner_cd"
		goto lowner
	Case 'lproj'
		iscurrvalcolumn = ''
		return ''
End Choose

lproj:
//Validate Project ID
lsProject = This.getItemString(al_row,"project_id")
//if not blank
If  lsProject > "" Then	
	If	len(trim(lsProject)) > 10 Then	
		This.Setfocus()
		This.SetColumn("project_id")
		iscurrvalcolumn = "project_id"
		Return "Project ID is > 10 Characters!"	
	ElseIf   Upper(trim(This.getItemString(al_row,"project_id"))) <> Upper(gs_project) Then
		This.Setfocus()
		This.SetColumn("project_id")
		iscurrvalcolumn = "project_id"
		Return "Must match Project ID that is active!"
	End If
//If blank
Else
	This.Setfocus()
	This.SetColumn("project_id")
	iscurrvalcolumn = "project_id"
	Return "'Project ID is required!"
End If  /*Project ID*/
	
lwh:
//Validate Warehouse Code
lsWh_code = This.getItemString(al_row,"wh_code")
//if not blank
If  lswh_code > "" Then	
		If	len(trim(lsWh_code)) > 10 Then
			This.Setfocus()
			This.SetColumn("wh_code")
			iscurrvalcolumn = "wh_code"
			Return "Warehouse code is > 10 Characters!"	
		Else	
			Select Count(*)  into :llCount
			from  Project_Warehouse
			Where project_id = :gs_project and wh_code = :lsWh_code
			Using SQLCA;
		
			If llCount <= 0 Then
				This.Setfocus()
				This.SetColumn("wh_code")
				iscurrvalcolumn = "wh_code"
				Return "Must be a valid warehouse code for the project ID!"
			End If	
		End if 
//If blank
Else
	This.Setfocus()
	This.SetColumn("wh_code")
	iscurrvalcolumn = "wh_code"
	return "'Warehouse code is required!"
End If  /*wh_code*/

lsku:
//Validate Sku
lsSku = This.getItemString(al_row,"Sku")
//if not blank
If  lsSku > "" Then	
		If	len(trim(lsSku)) > 50 Then
			This.Setfocus()
			This.SetColumn("sku")
			iscurrvalcolumn = "sku"
			Return "SKU is > 50 Characters!"	
		Else	
			Select Count(*)  into :llCount
			from  Item_master
			Where project_id = :gs_project and sku = :lsSKU
			Using SQLCA;
		
			If llCount <= 0 Then
				This.Setfocus()
				This.SetColumn("sku")
				iscurrvalcolumn = "sku"
				Return "Must be a valid SKU for the project ID!"
			End If	
		End if 
//If blank
Else
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	Return "'SKU is required!"
End If  /*SKU*/

lsupplier:
//Validate Supplier Code
lsSupplier = This.getItemString(al_row,"supp_code")
//if not blank
If  lsSupplier > "" Then	
		If	len(trim(lsSupplier)) > 20 Then
			This.Setfocus()
			This.SetColumn("supp_code")
			iscurrvalcolumn = "supp_code"
			Return "Supplier code > 20 Characters!"	
		Else	
				Select Count(*)  into :llCount
				from Supplier
				Where project_id = :gs_project and supp_code = :lsSupplier
				Using SQLCA;
				
				If 	llCount <= 0 Then
					This.Setfocus()
					This.SetColumn("supp_code")
					iscurrvalcolumn = "supp_code)"
					Return "Must be a valid Supplier code for the project ID!"
				End If			
		End if 
//If blank
Else
	This.Setfocus()
	This.SetColumn("supp_code")
	iscurrvalcolumn = "supp_code"
	Return "'Supplier code is required!"
End If /*Supplier Present*/

lowner:		
//Validate Owner code
lsOwner = This.getItemString(al_row,"owner_cd")
//if not blank
If  lsOwner  > "" Then	
		If	len(trim(lsOwner )) > 20 Then
			This.Setfocus()
			This.SetColumn("owner_cd")
			iscurrvalcolumn = "owner_cd"
			Return "Ownerr code > 20 Characters!"	
		Else	
			If 	gs_project <> "PANDORA" Then
				Select Count(*)  into :llCount
				from Owner
				Where project_id = :gs_project and owner_cd = :lsOwner
				Using SQLCA;			
			Else
				//Must be a valid owner cd from customer master
				Select 	Count(*)  into :llCount
				FROM 	dbo.Owner,
									dbo.Customer
				Where 	dbo.Owner.Project_ID 		= dbo.Customer.Project_ID
				and    	dbo.Owner.owner_cd			= dbo.Customer.Cust_Code
				and 		dbo.Owner.Owner_cd 		= :lsOwner
					and 		dbo.Customer.Customer_Type <> 'IN' 
				and 		dbo.Owner.Project_ID = :gs_project
				Using SQLCA;			
			End if
			
					If llCount <= 0 Then
						This.Setfocus()
						This.SetColumn("owner_cd")
						iscurrvalcolumn = "owner_cd"
						Return "Must be a valid Owner Code for the project ID!"
					End If
		End If
//If blank
Else
	This.Setfocus()
	This.SetColumn("owner_cd")
	iscurrvalcolumn = "owner_cd"
	Return "'Owner code is required!"
End If /*Owner */


iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();//Jxlim 03/03/2011 Import Itemmaster Min/Max table is Reorder_point
// ET3  05/24/2012 Add PONO to reorder point and therefore import

Long	llRowCount,	&
		llRowPos,	&
		llUpdate,	&
		llNew,		&		
		llDel,		&		
		llcount,		&		
		llOwner_id

Long llmin_rop, llmax_supply, llreorder
		
String	lsProject, lsWh_code, lsOwner_cd, lsSku, lsSupplier, lsErrText,	lsSQL, lsDelSQL
String 	lsMin_rop, lsMax_supply, lsReorder, lsPONO
Dec		ldMin_rop, ldMax_supply, ldReorder, ldTotal
String		lsMsg
			
llRowCount = This.RowCount()

llupdate = 0
llNew = 0
llDel = 0

SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; /* Jxlim 03/03/2011 Auto Commit Turned on to eliminate DB locks*/

//Update or Insert for each Row...
For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))	
	
	lsproject = left(trim(This.GetItemString(llRowPos,"project_id")),10)
	lswh_code = left(trim(This.GetItemString(llRowPos,"wh_code")),10)
	lsSku = left(trim(This.GetItemString(llRowPos,"sku")),50)
	lsSupplier = left(trim(This.GetItemString(llRowPos,"supp_code")),20)
	lsOwner_cd = left(trim(This.GetItemString(llRowPos,"owner_cd")),20)
	lsMin_rop = This.GetItemString(llRowPos,"min_rop")
	lsMax_supply = This.GetItemString(llRowPos,"max_supply")
	lsReorder = This.GetItemString(llRowPos,"reorder_qty")
	lsPONO = This.GetItemString(llRowPos,"PONO")
	if IsNull(lsPONO) or (lsPONO = '') then lsPONO = '-'
	
	ldMin_rop = Dec(lsMin_rop)
	ldMax_supply = Dec(lsMax_supply)
	ldReorder = Dec(lsReorder)
		
	If  	IsNull(lsMin_rop) or lsMin_rop = '0'  Then
		ldMin_rop = 0 
	End IF
	
	If	IsNull(lsMax_supply)  or lsMax_supply = '0'  Then
		ldMax_Supply = 0 
	End If
	
	If	IsNull(lsReorder)  or lsReorder = '0'  Then
		ldReorder = 0  
	End If
	
	//GailM 5/3/2019 DE10251 Hager:  Max supply onhand and Min Reorder Point - Cannot have a zero unless delete
	ldTotal = ldMin_rop + ldMax_supply + ldReorder
	If ldTotal > 0 and (ldMin_rop = 0 or ldMax_supply = 0 or ldReorder = 0) Then
		lsMsg = "Min/Max/Reorder Qty cannot be zero except when deleting row.~n~r " +&
					"Error at Row: " + string(llRowPos) + ".  " +&
					"~n~r~n~rSave has stopped.  Please investigate the row, repair and try again."
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox("Item Min/Max Reorder Point Error",lsMsg)
		Return -1
	End If

	//Jxlim 03/03/2011 - Build update statement dynamically, based on fields filled in on layout
	// so we dont clear out previously entered data if missing from layout
	
	llOwner_id = 0		//Initialize owner id
	
	//Must be a valid owner cd from customer master
	Select 	owner_id into :llOwner_id
	FROM 	dbo.Owner,
			dbo.Customer
	Where dbo.Owner.Project_ID = dbo.Customer.Project_ID
	and   dbo.Owner.owner_cd	= dbo.Customer.Cust_Code
	and 	dbo.Owner.Owner_cd 	= :lsOwner_cd	
	and 	dbo.Owner.Project_ID = :gs_project
	and 	dbo.Customer.Customer_Type <> 'IN' 
	Using SQLCA;		
	
	If llOwner_id  <= 0 Then				
		lsMsg = "Owner ID failed at row: " +string(llRowPos) + ".  OwnerCd " + lsOwner_cd + " not in Customer table." +&
			"~n~r~n~rSave has stopped.  Please investigate the row, repair and try again."
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox("Item Min/Max Reorder Point Error",lsMsg)
		Return -1
	End If

	If   ldMin_rop > 0 and ldMax_Supply > 0 and  ldReorder > 0  Then		
		lsSQL = "Update Reorder_point  Set "
		If lsproject > ' ' Then lsSQL += "project_id = '" + lsProject + "', "
		If lsWh_code > ' ' Then lsSQL += "wh_code = '" + lsWh_code + "', "
		If lsSku > ' ' Then lsSQL += "Sku = '" + lsSku + "', "
		If lsSupplier > ' ' Then lsSQL += "supp_code = '" + lsSupplier + "', "
		If llowner_id  > 0 Then lsSQL += "owner_id = " + string(llOwner_id) + ", "		
		If ldMin_rop > 0 Then lsSQL += "min_rop = " + lsMin_rop + ", "
		If ldMax_supply > 0 Then lsSQL += "max_supply_onhand = " + lsMax_Supply + ", "
		If ldReorder > 0 Then lsSQL += "reorder_qty = " + lsReorder
		If lsPONO > ' ' Then lsSQL += ", pono = '" + lsPONO + "' "    // ET3 - 393; adding PONO
		lsSQl += " Where Project_id = '" + lsProject + "' and wh_code = '" + lsWh_code + "' and Sku = '" + lsSku + "' and Supp_code = '" + lsSupplier + "' and Owner_id = '" + String(llOwner_id) + "'"
				
		Execute Immediate :LSSQL Using SQLCA;
		If sqlca.sqlcode <> 0 Then   //If not success
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			lsMsg = "Update failed at row: " +string(llRowPos) + " -  Reason: " + lsErrText + "~n~r~n~rSave has stopped.  Please investigate the row, repair and try again."
			MessageBox("Import Item Min/Max Reorder Point Error",lsMsg)
			Return -1
		End If
		
		If Sqlca.sqlnrows <> 1 Then /*Insert*/		
			
			Insert Into Reorder_point (Project_ID, SKU, Supp_Code, Wh_Code, Max_Supply_Onhand, Min_Rop, Reorder_Qty, Owner_Id, PONO)
			Values (:lsproject, :lsSku, :lsSupplier,:lsWh_Code,:ldMax_supply,:ldMin_rop,:ldreorder, :llOwner_id, :lsPONO)
			Using SQLCA;
			
			If sqlca.sqlcode <> 0 Then     //If not success
				lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
				Execute Immediate "ROLLBACK" using SQLCA;
				lsMsg = "Insert failed at row: " +string(llRowPos) + " -  Reason: " + lsErrText + "~n~r~n~rSave has stopped.  Please investigate the row, repair and try again."
				MessageBox("Import Item Min/Max Reorder Point Error",lsMsg)
				Return -1
			Else
				llnew ++
			End If
		Else /*update*/
			llupdate ++
		End If
	
	Else
	
	//Jxlim 03/14/2011  Delete if qty fields are 0 or blank	
	//Rule - If Min and Max and Reorder Qty = blank or 0, then delete the existing min, max, reorder numbers for that line.
	//If   ldMin_rop = 0 and ldMax_Supply = 0 and  ldReorder = 0  Then		
		
		lsDelSQL = "Delete From Dbo.Reorder_point"
		lsDelSQL += " Where Project_id = '" + lsProject + "' and wh_code = '" + lsWh_code + "' and Sku = '" + lsSku + "' and Supp_code = '" + lsSupplier + "' and Owner_id = '" + String(llOwner_id) + "'"

		Execute Immediate :LSDelSQL Using SQLCA;
		If sqlca.sqlcode <> 0 Then   //If not success
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			lsMsg = "Delete failed at row: " +string(llRowPos) + " -  Reason: " + lsErrText + "~n~r~n~rSave has stopped.  Please investigate the row, repair and try again."
			MessageBox("Import Item Min/Max Reorder Point Error",lsMsg)
			Return -1
		Else
			llDel ++
			//llupdate --
		End If	
	End If
	
Next

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "~r~rRecords Added: " + String(llNew) + + "~r~rRecords Deleted: " + String(llDel))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_item_min_max.create
call super::create
end on

on u_dw_import_item_min_max.destroy
call super::destroy
end on

event constructor;call super::constructor;// show column only if PANDORA
if gs_project = 'PANDORA' then
	this.Modify("PONO.Visible=TRUE")
	this.Modify("PONO_t.Visible=TRUE")
end if

end event

